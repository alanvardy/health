defmodule Health.UserPolicy do
  @moduledoc "Permissions for all exercise related items"
  alias Health.Account.{Roles, User}
  import Bitwise

  @behaviour Bodyguard.Policy
  @admin Roles.get(:admin)

  # Signed in users can access their settings
  # @spec authorize(any, any, any) :: boolean
  # def authorize(:edit, %User{roles: roles}, %User{})
  #     when @admin &&& roles > 0,
  #     do: true
  @spec authorize(any, any, any) :: boolean
  def authorize(:edit, %User{roles: roles}, %User{}) do
    admin = Roles.get(:admin)

    cond do
      (admin &&& roles) > 0 -> true
      true -> false
    end
  end

  def authorize(:update, %User{roles: roles}, %User{}) do
    admin = Roles.get(:admin)

    cond do
      (admin &&& roles) > 0 -> true
      true -> false
    end
  end

  # Catch-all: deny everything else
  def authorize(_, _, _), do: false
end
