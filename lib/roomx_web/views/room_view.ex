defmodule RoomxWeb.RoomView do
  use RoomxWeb, :view

  def activity_live_module(room) do
    case room.activity do
      "mines" -> RoomxWeb.RoomMinesLive
      "tateti" -> RoomxWeb.RoomTatetiLive
    end
    # {:safe, content}
  end
end
