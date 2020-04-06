defmodule SeaWorldInterface.Repo do
  use Ecto.Repo,
    otp_app: :sea_world_interface,
    adapter: Ecto.Adapters.Postgres
end
