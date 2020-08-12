defmodule RoomxWeb.MinesRoomLive do
  use RoomxWeb, :live_view

  alias Roomx.Rooms
  alias Roomx.Rooms.Room

  @impl true
  def mount(params, _session, socket) do
    room = Rooms.get_room_by_uuid!(params["session_id"])
    {:ok, assign(socket, room: room)}
  end

end
