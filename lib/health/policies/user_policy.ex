defmodule Health.UserPolicy do
  @moduledoc "Permissions for all user related items"

  @behaviour Bodyguard.Policy

  # Admin can edit and update user settings
  @spec authorize(any, any, any) :: boolean

  # Catch-all: deny everything else
  def authorize(_, _, _), do: false
end
