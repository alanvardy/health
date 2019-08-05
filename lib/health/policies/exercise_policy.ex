defmodule Health.ExercisePolicy do
  @moduledoc "Permissions for all exercise related items"
  alias Health.Account.User
  alias Health.Routine.Exercise

  @behaviour Bodyguard.Policy

  # Signed in users can access all exercises
  # Signed in users can edit/create/destroy any exercise
  @spec authorize(any, any, any) :: boolean
  def authorize(_, %User{}, %Exercise{}), do: true

  # Catch-all: deny everything else
  def authorize(_, _, _), do: false
end
