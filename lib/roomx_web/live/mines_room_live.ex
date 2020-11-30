defmodule RoomxWeb.MinesRoomLive do
  use RoomxWeb, :live_view

  alias Roomx.Rooms
  alias Roomx.Rooms.Room

  @topic "mines_room_event"

  def handle_event("discover_cell", %{ "cell" => value }, socket) do
    Phoenix.PubSub.broadcast_from(Roomx.PubSub, self(), @topic, {"discover_cell", %{ "cell" => value } })
    {:noreply, discover_cell(socket, value)}
  end

  # handle broadcast message
  def handle_info({"discover_cell", %{ "cell" => value } } = loquesea, socket) do
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
    total_bombs = 10
    map = Roomx.Mines.generate_map(cols,rows,total_bombs)
    discovered = []
    game_state = [ room: room.name, game_id: game_id, map: map, cols: cols, rows: rows, total_bombs: total_bombs, discovered: discovered ]
    Roomx.MinesGamesAgent.update(game_id, game_state)
    {:ok, assign(socket, :game_state, game_state)}
  end

  @impl true
  def mount(params, _session, socket) do
    Phoenix.PubSub.subscribe(Roomx.PubSub, @topic)
    game_id = params["game_id"]
    case Roomx.MinesGamesAgent.get(game_id) do
      nil ->  new_game(game_id, socket)
      # player join
      existing_game_state -> {:ok, assign(socket, :game_state, existing_game_state)}
    end
  end

end
