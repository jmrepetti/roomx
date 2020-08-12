defmodule Roomx.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "rooms" do
    field :activity, :string #buscaminas:sessionid
    field :name, :string #buscando minas
    field :uuid, :string #uuid
    #TODO: max capacitu/plauers/visitors/etc (should remeber player returning?)
    # field :max_clients, :integer

    timestamps()
  end

  @doc false
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :uuid, :activity])
    # |> validate_required([:name, :activity])
    |> validate_required([:name])
  end
end
