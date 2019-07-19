defmodule Health.Account do
  @moduledoc "Accounts context for dealing with Users and their settings"

  alias Health.Account.User
  alias Health.Repo

  use Pow.Ecto.Context,
    repo: Health.Repo,
    user: Health.Account.User

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
