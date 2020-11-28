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
    socket
      |> update(:discovered, fn discovered -> [String.to_integer(value) | discovered] end)
  end


  @impl true
  def mount(params, _session, socket) do
    Phoenix.PubSub.subscribe(Roomx.PubSub, @topic)
    room = Rooms.get_room_by_uuid!(params["session_id"])
    cols = 9
    rows = 9
    total_bombs = 10
    map = Roomx.Mines.generate_map(cols,rows,total_bombs)
    discovered = []
    state = [ room: room, map: map, cols: cols, rows: rows, total_bombs: total_bombs, discovered: discovered ]
    {:ok, assign(socket, state)}
  end

end
