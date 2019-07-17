defmodule Health.ExercisePolicy do
  @moduledoc "Permissions for all exercise related items"
  alias Health.Account.User
  alias Health.Exercise

  @behaviour Bodyguard.Policy

  # Signed in users can access all exercises
  @spec authorize(any, any, any) :: boolean
  def authorize(_, %User{}, Exercise), do: true

  # Signed in users can edit/create/destroy any exercise
  def authorize(_, %User{}, %Exercise{}), do: true

  # Catch-all: deny everything else
  def authorize(_, _, _), do: false

end
