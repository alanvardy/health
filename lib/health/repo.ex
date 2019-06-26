defmodule Health.Repo do
  use Ecto.Repo,
    otp_app: :health,
    adapter: Ecto.Adapters.Postgres
end
