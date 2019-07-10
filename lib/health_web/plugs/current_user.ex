defmodule HealthWeb.Plugs.CurrentUser do
  @moduledoc """
    Adds current_user to assigns if user is logged in
    (for use in templates)
    """

  def init(options), do: options

  def call(conn, _opts) do
    Plug.Conn.assign(conn, :current_user, Pow.Plug.current_user(conn))
  end
end
