defmodule Health.Email do
  @moduledoc "Handles sending email"
  alias Health.Email.{Content, Contact}

  @spec contact(Health.Email.Content.t()) :: Bamboo.Email.t()
  def contact(%Content{} = content), do: Contact.compose(content)

end