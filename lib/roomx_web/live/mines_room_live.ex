defmodule RoomxWeb.MinesRoomLive do
  use RoomxWeb, :live_view

  alias Roomx.Rooms
  alias Roomx.Rooms.Room

  defp game_topic(socket) do
    "mines_room_event_#{socket.assigns[:game_state][:game_id]}"
  end

  def handle_event("discover_cell", %{ "cell" => value }, socket) do
    Phoenix.PubSub.broadcast(Roomx.PubSub, game_topic(socket), {"discover_cell", %{ "cell" => value } })
    {:noreply, socket}
  end

  # handle broadcast message
  def handle_info({"discover_cell", %{ "cell" => value }}, socket) do
    {:noreply, discover_cell(socket, value)}
  end

  def discover_cell(socket, value) do
    socket = socket
      |> update(:game_state, fn game_state -> Keyword.put(game_state, :discovered, [String.to_integer(value) | game_state[:discovered]] ) end)
    Roomx.MinesGamesAgent.update(socket.assigns.game_state[:game_id], socket.assigns.game_state)
    socket
  end


  def new_game(game_id, socket) do
    room = Rooms.get_room_by_uuid!(game_id)
    cols = 9
    rows = 9
    total_bombs = 6
    map = Roomx.Mines.generate_map(cols,rows,total_bombs)
    discovered = []
    # discovered = Enum.map(0..cols*rows, &(&1)) #discover all
    game_state = [ room: room.name, game_id: game_id, map: map, cols: cols, rows: rows, total_bombs: total_bombs, discovered: discovered ]
    Roomx.MinesGamesAgent.update(game_id, game_state)
    assign(socket, :game_state, game_state)
  end

  @impl true
  def mount(params, _session, socket) do
    game_id = params["game_id"]
    socket = case Roomx.MinesGamesAgent.get(game_id) do
      # _ -> new_game(game_id, socket)
      nil -> new_game(game_id, socket)
      # player join
      existing_game_state -> assign(socket, :game_state, existing_game_state)
    end
    Phoenix.PubSub.subscribe(Roomx.PubSub, game_topic(socket))
    {:ok, socket}
  end

end
