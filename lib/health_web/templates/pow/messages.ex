defmodule HealthWeb.Pow.Messages do
  @moduledoc "Flash messages for POW actions"
  use Pow.Phoenix.Messages
  use Pow.Extension.Phoenix.Messages,
    extensions: [PowResetPassword]

  import HealthWeb.Gettext

  def user_not_authenticated(_conn), do: gettext("You need to sign in to see this page.")
  def signed_in(_conn), do: gettext("Welcome back!")
  def signed_out(_conn), do: gettext("Goodbye!")
  def invalid_credentials(_conn), do: gettext("Sorry, invalid credentials")

  # Message methods for extensions has to be prepended with the snake cased
  # extension name. So the `email_has_been_sent/1` method from
  # `PowResetPassword` is written as `pow_reset_password_email_has_been_sent/1`
  # in your messages module.
end
