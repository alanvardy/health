defmodule Health.Helpers do
  @moduledoc "Test helpers"
  use Phoenix.ConnTest
  # alias HealthWeb.Router.Helpers, as: Routes
  # @endpoint HealthWeb.Endpoint

  def log_in(conn, user) do
    Pow.Plug.assign_current_user(conn, user, otp_app: :health)
  end
end
