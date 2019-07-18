defmodule Health.Policies.Roles do
  @moduledoc """
  Handles user roles for authentication
  """
  alias Health.Account.User
  use Bitwise

  # You can rename roles and add new roles to the end,
  # but do not delete roles or change their order.
  @roles [:admin, :member]

  @doc "returns the bitwise value of a role"
  @spec get((any -> any)) :: integer
  def get(role) do
    index = Enum.find_index(@roles, role)

    2
    |> :math.pow(index)
    |> round()
  end

  @doc "Get user roles as a list of strings"
  @spec user_roles(Health.Account.User.t()) :: [String.t()]
  def user_roles(%User{roles: roles}) do
    @roles
    |> Enum.map(fn r -> {r, get(r)} end)
    |> Enum.filter(fn {_k, v} -> (roles &&& v) == 1 end)
    |> Enum.map(fn {k, _v} -> nice_string(k) end)
  end

  @doc "Get all roles as a list of strings"
  @spec all_roles() :: [String.t()]
  def all_roles do
    @roles
    |> Enum.map(fn {k, _v} -> nice_string(k) end)
  end

  defp nice_string(atom) do
    atom
    |> Atom.to_string()
    |> String.capitalize()
  end
end
