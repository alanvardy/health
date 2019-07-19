defmodule Health.Account do
  @moduledoc "Accounts context for dealing with Users and their settings"

  alias Ecto.Changeset
  alias Health.Repo
  alias Health.Account.User

  use Pow.Ecto.Context,
    repo: Health.Repo,
    user: Health.Account.User

  @spec change_settings(%User{}) :: %Changeset{}
  def change_settings(%User{} = user) do
    User.changeset(user, %{})
  end

  @spec update_settings(
          Health.Account.User.t(),
          :invalid | %{optional(:__struct__) => none, optional(atom | binary) => any}
        ) :: any
  def update_settings(%User{} = user, attrs) do
    pow_update(user, attrs)
  end

  @spec get_users :: [User.t]
  def get_users do
    User |> Repo.all
  end
end
