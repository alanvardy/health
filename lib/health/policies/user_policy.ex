defmodule Health.UserPolicy do
  @moduledoc "Permissions for all exercise related items"
  alias Health.Account.User

  @behaviour Bodyguard.Policy

  # Signed in users can access their settings
  @spec authorize(any, any, any) :: boolean
  def authorize(action, %User{id: id}, %User{id: id})
      when action in [:edit, :update],
      do: true

  # Catch-all: deny everything else
  def authorize(_, _, _), do: false
end
