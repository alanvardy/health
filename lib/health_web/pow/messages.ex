defmodule HealthWeb.Pow.Messages do
  @moduledoc """
  Additional Flash messages for Pow
  """
  use Pow.Phoenix.Messages
  use Pow.Extension.Phoenix.Messages, extensions: [PowResetPassword]

  import HealthWeb.Gettext

  # For a list of messages:
  # https://github.com/danschultzer/pow/blob/master/lib/pow/phoenix/messages.ex

  def user_has_been_created(_conn), do: gettext("Hey nice sign up")
  def signed_in(_conn), do: gettext("I knew you'd be back")
  def signed_out(_conn), do: gettext("Yea that's right, you go")
end
