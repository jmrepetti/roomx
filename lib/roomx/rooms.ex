defmodule Roomx.Rooms do

  import Ecto.Query, warn: false
  alias Roomx.Repo
  alias Roomx.Rooms.Room

  def all do
    Repo.all(from r in Room, order_by: [desc: r.id])
  end
end
