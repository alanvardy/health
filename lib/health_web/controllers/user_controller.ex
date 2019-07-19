defmodule HealthWeb.UserController do
  use HealthWeb, :controller
  alias Health.Account
  alias Health.Account.User
  alias Plug.Conn

  action_fallback HealthWeb.FallbackController

  @spec index(%Conn{assigns: %{current_user: %User{}}}, any) ::
          {:error, any} | %Conn{}
  def index(conn, _params) do
    user = get_current_user(conn)
    users = Account.get_users()

    with :ok <- Bodyguard.permit(User, :index, user, user) do
      render(conn, "index.html", users: users)
    end
  end

  @spec edit(%Conn{assigns: %{current_user: %User{}}}, any) ::
          {:error, any} | %Conn{}
  def edit(conn, %{id: id}) do
    current_user = get_current_user(conn)
    user = Account.pow_get_by(%{id: id})
    changeset = User.changeset(user, %{})
    action = Routes.user_path(conn, :update, user)

    with :ok <- Bodyguard.permit(User, :edit, current_user, user) do
      render(conn, "edit.html", user: user, changeset: changeset, action: action)
    end
  end

  @spec update(Plug.Conn.t(), map) :: {:error, any} | Plug.Conn.t()
  def update(conn, %{"id" => id, "user" => user_params}) do
    current_user = get_current_user(conn)
    user = Account.pow_get_by(%{id: id})

    with :ok <- Bodyguard.permit(User, :update, current_user, user) do
      case Account.update_settings(user, user_params) do
        {:ok, _user} ->
          conn
          |> put_flash(:info, "User updated successfully.")
          |> redirect(to: Routes.user_path(conn, :edit, user))

        {:error, %Ecto.Changeset{} = changeset} ->
          with :ok <- Bodyguard.permit(User, :edit, current_user, user) do
            action = Routes.user_path(conn, :update, user)

            conn
            |> put_flash(:error, "User could not be updated")
            |> render("edit.html", user: user, changeset: changeset, action: action)
          end
      end
    end
  end

  @spec get_current_user(%Conn{assigns: %{current_user: %User{}}}) :: %User{}
  def get_current_user(conn) do
    conn.assigns.current_user
  end
end