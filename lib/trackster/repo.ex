defmodule Trackster.Repo do
  use Ecto.Repo,
    otp_app: :trackster,
    adapter: Ecto.Adapters.Postgres
end
