defmodule Health.Stats.Policy do
  @moduledoc "Permissions for all stats related items"

  alias Health.Stats.Log
  alias Health.Users.User
  @behaviour Bodyguard.Policy

  def get_current_user(conn) do
    conn.assigns.current_user
  end

  # Users can access their own logs
  def authorize(action, %User{id: user_id}, %Log{user_id: user_id})
      when action in [:show, :edit, :update, :delete],
      do: true

  # Index will only show that user's logs, and can create new ones
  def authorize(action, %User{}, _)
      when action in [:index, :new],
      do: true

  # Catch-all: deny everything else
  def authorize(_, _, _), do: false
end
