defmodule Health.Policies.Exercise do
  @moduledoc "Permissions for all exercise related items"
  alias Health.Exercise
  alias Health.Users.User

  @behaviour Bodyguard.Policy

  # Signed in users can access all exercises
  def authorize(action, %User{}, Exercise), do: true

  # Signed in users can edit/create/destroy any exercise
  def authorize(action, %User{}, %Exercise{}), do: true

  # Catch-all: deny everything else
  def authorize(_, _, _), do: false

end
