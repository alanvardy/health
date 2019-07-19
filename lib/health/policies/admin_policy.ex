defmodule Health.AdminPolicy do
  @moduledoc "Permissions for all administrative related items"
  alias Health.Account.{Admin, Role, User}
  import Bitwise

  @behaviour Bodyguard.Policy
  @admin Role.get(:admin)

  # Admin can edit and update user settings
  @spec authorize(any, any, any) :: boolean
  def authorize(action, %User{roles: roles}, %Admin{})
      when (@admin &&& roles) > 0 and action in [:index, :edit, :update],
      do: true

  # Catch-all: deny everything else
  def authorize(_, _, _), do: false
end