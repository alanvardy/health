defmodule HealthWeb.Pow.Messages do
  @moduledoc """
  Additional Flash messages for Pow
  """
  alias Plug.Conn
  use Pow.Phoenix.Messages
  import HealthWeb.Gettext

  # For a list of messages:
  # https://github.com/danschultzer/pow/blob/master/lib/pow/phoenix/messages.ex

  @spec user_has_been_created(%Conn{}) :: String.t()
  def user_has_been_created(_conn), do: gettext("Welcome!")
  @spec signed_in(%Conn{}) :: String.t()
  def signed_in(_conn), do: gettext("Welcome back!")
  @spec signed_out(%Conn{}) :: String.t()
  def signed_out(_conn), do: gettext("Goodbye!")
end
