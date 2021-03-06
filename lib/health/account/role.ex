defmodule Health.Account.Role do
  @moduledoc """
  Handles user roles for authentication

  You can rename roles and add new roles to the end,
  but do not delete roles or change their order.
  Just rename the role to disabled or something clever and move on =)

  i.e.
  @roles [:member, :disabled, :admin, :village_idiot]
  """
  alias Health.Account.{EditableUser, User}
  use Bitwise

  @roles [:member, :admin]

  @doc """
  Returns the bitwise value of a role for comparison with a user's value

  ## Example

  Using Bodyguard

  ```elixir
  @admin MyApp.Role.get(:admin)


  def authorize(action, %MyApp.User{roles: roles}, %MyApp.User{})
      when (@admin &&& roles) > 0 and action in [:edit, :update],
      do: true
  ```
  """
  @spec get(atom) :: integer
  def get(role) do
    index = Enum.find_index(@roles, fn x -> x == role end)

    2
    |> :math.pow(index)
    |> round()
  end

  @doc """
  Checks whether a user has a role

  ## Example

  ```html
  <%= if is?(@current_user, :admin) do %>
    Stuff that non admin shouldn't see
  <% end %>
  ```
  """
  @spec is?(%User{}, atom) :: boolean
  def is?(%User{roles: roles}, role) do
    (roles &&& get(role)) > 0
  end

  @doc """
  Get user roles as a list of strings to add to your templates

  ## Example

  ```html
  Role:
  <ul>
    <%= for role <- MyApp.Role.user_roles(@user) do %>
      <li><%= role %></li>
    <% end %>
  </ul>
  ```

  """
  @spec user_roles(%User{} | %EditableUser{}) :: [String.t()]
  def user_roles(%{roles: 0}), do: ["none"]

  def user_roles(%{roles: roles}) do
    @roles
    |> Enum.map(fn r -> {r, get(r)} end)
    |> Enum.filter(fn {_k, v} -> (roles &&& v) > 0 end)
    |> Enum.map(fn {k, _v} -> nice_string(k) end)
  end

  @doc """
  Get all roles as a list of maps

  See user_roles/1 for an example of use
  """
  @spec all_roles() :: [String.t()]
  def all_roles do
    @roles
    |> Enum.map(fn k -> %{name: nice_string(k), value: get(k)} end)
  end

  defp nice_string(atom) do
    atom
    |> Atom.to_string()
    |> String.capitalize()
  end
end
