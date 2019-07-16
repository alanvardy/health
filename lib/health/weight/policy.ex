defmodule Health.Weight.Policy do
  @moduledoc "Permissions for all stats related items"

  alias Health.Account.User
  alias Health.Weight.Log
  @behaviour Bodyguard.Policy

  # Users can access their own logs
  @spec authorize(any, any, any) :: boolean
  def authorize(action, %User{id: user_id}, %Log{user_id: user_id})
      when action in [:edit, :update, :delete],
      do: true

  # Can create new logs
  def authorize(:create, %User{}, %Log{}), do: true

  # Can see their index
  def authorize(:index, %User{}, Log), do: true

  def authorize(:long_term, %User{}, Log), do: true

  # Catch-all: deny everything else
  def authorize(_, _, _), do: false

end
