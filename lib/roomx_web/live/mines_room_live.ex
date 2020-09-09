defmodule RoomxWeb.MinesRoomLive do
  use RoomxWeb, :live_view

  alias Roomx.Rooms
  alias Roomx.Rooms.Room

  @impl true
  def mount(params, _session, socket) do
    room = Rooms.get_room_by_uuid!(params["session_id"])
    cols = 9
    rows = 9
    total_bombs = 10
    map = Roomx.Mines.generate_map(cols,rows,total_bombs)
    state = [room: room, map: map, cols: cols, rows: rows, total_bombs: total_bombs ]
    {:ok, assign(socket, state: state)}
  end

end
