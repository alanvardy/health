defmodule Health.Stats.Policy do
  @moduledoc "Permissions for all stats related items"

  alias Health.Stats.Log
  alias Health.Users.User
  @behaviour Bodyguard.Policy

  # Users can access their own logs
  def authorize(action, %User{id: user_id}, %Log{user_id: user_id})
      when action in [:show, :edit, :update, :delete],
      do: true

  # Can create new logs
  def authorize(action, %User{}, %Log{})
      when action in [:new, :create],
      do: true

  # Can see their index
  def authorize(:index, %User{}, Log), do: true

  # Catch-all: deny everything else
  def authorize(_, _, _), do: false
end
