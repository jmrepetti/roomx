defmodule Roomx.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :activity, :string #buscaminas:sessionid
    field :name, :string #buscando minas
    field :uuid, :string #uuid

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :uuid, :activity])
    |> validate_required([:name, :activity])
  end
end
