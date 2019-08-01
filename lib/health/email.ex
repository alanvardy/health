defmodule Health.Email do
  import Bamboo.Email
  alias Health.Email.Content

  @spec feedback_email(Health.Email.Content.t()) :: Bamboo.Email.t()
  def feedback_email(%Content{from_email: from_email, name: name} = content) do
    new_email(
      to: "alanvardy@gmail.com",
      from: from_email,
      subject: "[health.vardy.codes] Message from #{name}",
      html_body: feedback_html_body(content),
      text_body: feedback_text_body(content)
    )
  end

  @spec feedback_html_body(Health.Email.Content.t()) :: String.t()
  def feedback_html_body(%Content{from_email: from_email, name: name, message: message}) do
    """
      You have received a new message from health.vardy codes

      <strong>Email:</strong> #{from_email}
      <strong>Name:</strong> #{name}
      <strong>Message:</strong>
      #{message}
    """
  end

  @spec feedback_text_body(Health.Email.Content.t()) :: String.t()
  def feedback_text_body(%Content{from_email: from_email, name: name, message: message}) do
    """
      You have received a new message from health.vardy codes

      Email: #{from_email}
      Name: #{name}
      Message:
      #{message}
    """
  end
end