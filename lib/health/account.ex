defmodule Health.Account do
  @moduledoc "Accounts context for dealing with Users and their settings"

  alias Health.Account.EditableUser
  alias Health.Repo

  use Pow.Ecto.Context,
    repo: Health.Repo,
    user: Health.Account.User

  @spec list_admin_users :: [User.t()]
  def list_admin_users do
    EditableUser |> Repo.all()
  end

  @spec get_admin(integer) :: %EditableUser{} | :error
  def get_admin(id), do: Repo.get(EditableUser, id)

  @spec update_admin(Health.Account.EditableUser.t(), map) :: {:error, map} | {:ok, map}
  def update_admin(%EditableUser{} = user, attrs) do
    pow_update(user, attrs)
  end
end
