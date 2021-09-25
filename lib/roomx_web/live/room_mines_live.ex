defmodule RoomxWeb.RoomMinesLive do
  use RoomxWeb, :live_view

  alias Roomx.Rooms
  alias Roomx.Rooms.Room

  defp room_id(socket), do: socket.assigns.room.uuid
  defp room_topic(socket), do: "room:#{room_id(socket)}"

  def handle_event("discover_cell", %{ "cell" => value }, socket) do
    Phoenix.PubSub.broadcast(Roomx.PubSub, room_topic(socket), {"discover_cell", %{ "cell" => value } })
    {:noreply, socket}
  end

  # handle broadcast message
  def handle_info({"discover_cell", %{ "cell" => value }}, socket) do
    {:noreply, discover_cell(socket, value)}
  end

  def discover_cell(socket, value) do
    socket =
      socket
      |> update(:game_state, fn game_state ->
        Keyword.put(game_state, :discovered, [String.to_integer(value) | game_state[:discovered]] )
      end)
    Roomx.RoomsAgent.update(room_id(socket), socket.assigns.game_state)
    socket
  end

  def new_game(room_id, socket) do
    room = Rooms.get_room_by_uuid!(room_id)
    #TODO: remove harcoded values for map with user provided params
    cols = 9
    rows = 9
    total_bombs = 6
    map = Roomx.Mines.generate_map(cols,rows,total_bombs)
    # discovered = Enum.map(0..cols*rows, &(&1)) #discover all
    game_state = [
      map: map,
      cols: cols,
      rows: rows,
      total_bombs: total_bombs,
      discovered: []
    ]
    Roomx.RoomsAgent.update(room_id, game_state)
    assign(socket, room: room, game_state: game_state)
  end

  def load_game(room_id, existing_game_state, socket) do
    room = Rooms.get_room_by_uuid!(room_id)
    assign(socket, room: room, game_state: existing_game_state)
  end

  @impl true
  def mount(params, _session, socket) do
    room_id = params["room_id"]
    socket = case Roomx.RoomsAgent.get(room_id) do
      # _ -> new_game(room_id, socket)
      nil -> new_game(room_id, socket)
      # player join
      existing_game_state -> load_game(room_id, existing_game_state, socket)
    end
    Phoenix.PubSub.subscribe(Roomx.PubSub, room_topic(socket))
    {:ok, socket}
  end

end
