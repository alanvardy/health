defmodule HealthWeb.Pow.Messages do
  use Pow.Phoenix.Messages
  use Pow.Extension.Phoenix.Messages, extensions: [PowResetPassword]

  import HealthWeb.Gettext

  # For a list of messages:
  # https://github.com/danschultzer/pow/blob/master/lib/pow/phoenix/messages.ex

  def user_has_been_created(_conn), do: gettext("Hey nice sign up")
  def signed_in(_conn), do: gettext("I knew you'd be back")
  def signed_out(_conn), do: gettext("Yea that's right, you go")

  # Message methods for extensions has to be prepended with the snake cased
  # extension name. So the `email_has_been_sent/1` method from
  # `PowResetPassword` is written as `pow_reset_password_email_has_been_sent/1`
  # in your messages module.
  # def pow_reset_password_email_has_been_sent(_conn), do: gettext("Email ya. An email with reset instructions has been sent to you. Please check your inbox.")
end
