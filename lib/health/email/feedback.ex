defmodule Health.Email.Contact do
  import Bamboo.Email
  alias Health.Email.Content

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

  @spec contact_html_body(Health.Email.Content.t()) :: String.t()
  defp contact_html_body(%Content{from_email: from_email, name: name, message: message}) do
    """
      You have received a new message from health.vardy codes

      <strong>Email:</strong> #{from_email}
      <strong>Name:</strong> #{name}
      <strong>Message:</strong>
      #{message}
    """
  end

  @spec contact_text_body(Health.Email.Content.t()) :: String.t()
  defp contact_text_body(%Content{from_email: from_email, name: name, message: message}) do
    """
      You have received a new message from health.vardy codes

      Email: #{from_email}
      Name: #{name}
      Message:
      #{message}
    """
  end
end
