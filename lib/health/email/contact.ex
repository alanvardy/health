defmodule Health.Email.Contact do
  @moduledoc """
  Contact form email to be sent to admin
  """
  import Bamboo.Email
  alias Health.Email.Content
  import Ecto.Changeset

  @spec compose(Health.Email.Content.t()) :: Bamboo.Email.t()
  def compose(%Content{from_email: from_email, name: name} = content) do
    new_email(
      to: "alanvardy@gmail.com",
      from: from_email,
      subject: "[health.vardy.codes] Message from #{name}",
      html_body: contact_html_body(content),
      text_body: contact_text_body(content)
    )
  end

  @spec changeset(struct(), map()) :: %Ecto.Changeset{}
  def changeset(content, attrs) do
    {content, Content.types()}
    |> cast(attrs, [:from_email, :name, :message])
    |> validate_required([:from_email, :name, :message])
    |> validate_length(:message, min: 10, max: 1000)
  end

  @spec contact_html_body(Health.Email.Content.t()) :: String.t()
  defp contact_html_body(%Content{from_email: from_email, name: name, message: message}) do
    """
      <p>You have received a new message from health.vardy.codes</p>
      <p>
      <strong>Email:</strong> #{from_email} <br>
      <strong>Name:</strong> #{name} <br>
      <strong>Message:</strong> <br>
      #{message}
      </p>
    """
  end

  @spec contact_text_body(Health.Email.Content.t()) :: String.t()
  defp contact_text_body(%Content{from_email: from_email, name: name, message: message}) do
    """
      You have received a new message from health.vardy.codes

      Email: #{from_email}
      Name: #{name}
      Message:
      #{message}
    """
  end
end
