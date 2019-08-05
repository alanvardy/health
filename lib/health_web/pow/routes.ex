defmodule HealthWeb.Pow.Routes do
  @moduledoc """
  Overrides the pow default routes
  """
  use Pow.Phoenix.Routes
  alias HealthWeb.Router.Helpers, as: Routes

  @doc "Return to main page after signing out"
  def after_sign_out_path(conn), do: Routes.page_path(conn, :index)
end
