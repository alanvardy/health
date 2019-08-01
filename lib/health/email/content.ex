defmodule Health.Email.Content do
  @moduledoc "The content for an email message"
  defstruct from_email: nil, to_email: nil, name: nil, message: nil

  def types do
    %{from_email: :string, to_email: :string, name: :string, message: :string}
  end
end
