defmodule HealthWeb.Plugs.CurrentUser do
  @moduledoc """
  Adds current_user to assigns if user is logged in
  (for use in templates)
  """
  # coveralls-ignore-start
  def init(options), do: options
  # coveralls-ignore-stop

  def call(conn, _opts) do
    Plug.Conn.assign(conn, :current_user, Pow.Plug.current_user(conn))
  end
end
