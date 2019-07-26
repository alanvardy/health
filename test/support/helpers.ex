defmodule Health.Helpers do
  @moduledoc "Test helpers"
  use Phoenix.ConnTest

  @spec log_in(%Plug.Conn{}, any) :: %Plug.Conn{}
  def log_in(conn, user) do
    Pow.Plug.assign_current_user(conn, user, otp_app: :health)
  end

  @spec insert_and_log_in(%Plug.Conn{}, atom) :: %Plug.Conn{}
  def insert_and_log_in(conn, user) do
    user = Health.Factory.insert(user)
    Pow.Plug.assign_current_user(conn, user, otp_app: :health)
  end
end
