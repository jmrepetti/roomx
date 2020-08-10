defmodule Roomx.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :uuid, :string
      add :activity, :string

      timestamps()
    end

  end
end
