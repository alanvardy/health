defmodule Health.UserPolicy do
  @moduledoc "Permissions for all exercise related items"
  alias Health.Account.{Roles, User}
  import Bitwise

  @behaviour Bodyguard.Policy
  @admin Roles.get(:admin)

  # Admin can edit and update user settings
  @spec authorize(any, any, any) :: boolean
  def authorize(action, %User{roles: roles}, %User{})
      when (@admin &&& roles) > 0 and action in [:index, :edit, :update],
      do: true

  # Catch-all: deny everything else
  def authorize(_, _, _), do: false
end
