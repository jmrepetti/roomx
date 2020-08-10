defmodule RoomxWeb.RoomsLive do
  use RoomxWeb, :live_view

  alias Roomx.Rooms
  alias Roomx.Rooms.Room

  @impl true
  def mount(_params, _session, socket) do
    rooms = Rooms.all()
    {:ok, assign(socket, rooms: rooms)}
  end

end
