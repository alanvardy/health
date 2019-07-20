defmodule Health.Account do
  @moduledoc "Accounts context for dealing with Users and their settings"

  alias Health.Account.EditableUser
  alias Health.Repo

  use Pow.Ecto.Context,
    repo: Health.Repo,
    user: Health.Account.User

  @spec list_editable_users :: [User.t()]
  def list_editable_users do
    EditableUser |> Repo.all()
  end

  @spec get_editable_user(integer) :: %EditableUser{} | :error
  def get_editable_user(id), do: Repo.get(EditableUser, id)

  @spec update_editable_user(Health.Account.EditableUser.t(), map) :: {:error, map} | {:ok, map}
  def update_editable_user(%EditableUser{} = user, attrs) do
    pow_update(user, attrs)
  end
end
