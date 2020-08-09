defmodule Roomx.Repo do
  use Ecto.Repo,
    otp_app: :roomx,
    adapter: Ecto.Adapters.Postgres
end
