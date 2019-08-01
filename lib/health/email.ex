defmodule Health.Email do
  @moduledoc "Handles sending email"
  alias Health.Email.{Contact, Content}
  use Bamboo.Mailer, otp_app: :health

  @spec contact(Health.Email.Content.t()) :: Bamboo.Email.t()
  def contact(%Content{} = content), do: Contact.compose(content)

  @spec send_contact_message(map) :: none
  def send_contact_message(attrs) do
    %Content{}
    |> Contact.changeset(attrs)
    |> Contact.compose()
    |> deliver_now
  end
end
