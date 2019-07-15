defmodule HealthWeb.LogController do
  use HealthWeb, :controller
  alias Health.Stats
  alias Health.Stats.{Calculations, Log}
  alias Health.Users.User
  alias Plug.Conn

  action_fallback HealthWeb.FallbackController

  @spec index(%Conn{assigns: %{current_user: %User{}}}, any) ::
          {:error, any} | %Conn{}
  def index(conn, _params) do
    user = get_current_user(conn)
    logs = Stats.list_logs(user, limit: 14)
    log = %Log{}
    changeset = Stats.change_log(log)
    trends = Calculations.adjusted_weights(logs)
    estimate = Calculations.estimate_trend(trends)

    with :ok <- Bodyguard.permit(Stats, :index, user, Log) do
      render(conn, "index.html", logs: logs, trends: trends, changeset: changeset, estimate: estimate)
    end
  end

  @spec create(%Conn{assigns: %{current_user: %User{}}}, %{log: map}) ::
          {:error, any} | %Conn{}
  def create(conn, %{log: log_params}) do
    user = get_current_user(conn)
    log = %Log{}
    log_params = Map.put(log_params, :user_id, user.id)

    with :ok <- Bodyguard.permit(Stats, :create, user, log) do
      case Stats.create_log(log_params) do
        {:ok, _log} ->
          conn
          |> put_flash(:info, "Log created successfully.")
          |> redirect(to: Routes.log_path(conn, :index))

        {:error, %Ecto.Changeset{} = changeset} ->
          with :ok <- Bodyguard.permit(Stats, :index, user, Log) do
            user = get_current_user(conn)
            logs = Stats.list_logs(user)
            trends = Calculations.adjusted_weights(logs)
            estimate = Calculations.estimate_trend(trends)

            conn
            |> put_flash(:error, "Your log could not be created")
            |> render("index.html", changeset: changeset, logs: logs, trends: trends, estimate: estimate)
          end
      end
    end
  end

  @spec edit(%Conn{assigns: %{current_user: %User{}}}, map) :: {:error, any} | %Conn{}
  def edit(conn, %{"id" => id}) do
    user = get_current_user(conn)
    log = Stats.get_log!(id)
    changeset = Stats.change_log(log)

    with :ok <- Bodyguard.permit(Stats, :edit, user, log) do
      render(conn, "edit.html", log: log, changeset: changeset)
    end
  end

  @spec update(%Conn{assigns: %{current_user: %User{}}}, map) ::
          {:error, any} | %Conn{}
  def update(conn, %{"id" => id, "log" => log_params}) do
    user = get_current_user(conn)
    log = Stats.get_log!(id)

    with :ok <- Bodyguard.permit(Stats, :update, user, log) do
      case Stats.update_log(log, log_params) do
        {:ok, _log} ->
          conn
          |> put_flash(:info, "Log updated successfully.")
          |> redirect(to: Routes.log_path(conn, :index))

        {:error, %Ecto.Changeset{} = changeset} ->
          with :ok <- Bodyguard.permit(Stats, :edit, user, log) do
            conn
            |> put_flash(:error, "Your log could not be updated")
            |> render("edit.html", log: log, changeset: changeset)
          end
      end
    end
  end

  @spec delete(%Conn{assigns: %{current_user: %User{}}}, map) ::
          {:error, any} | %Conn{}
  def delete(conn, %{"id" => id}) do
    user = get_current_user(conn)
    log = Stats.get_log!(id)

    with :ok <- Bodyguard.permit(Stats, :delete, user, log) do
      {:ok, _log} = Stats.delete_log(log)

      conn
      |> put_flash(:info, "Log deleted successfully.")
      |> redirect(to: Routes.log_path(conn, :index))
    end
  end

  @spec long_term(%Conn{assigns: %{current_user: %User{}}}, any) ::
          {:error, any} | %Conn{}
  def long_term(conn, _params) do
    user = get_current_user(conn)
    logs = Stats.list_logs(user)
    trends = Calculations.adjusted_weights(logs)
    estimate = Calculations.estimate_trend(trends)

    with :ok <- Bodyguard.permit(Stats, :long_term, user, Log) do
      render(conn, "long_term.html", logs: logs, trends: trends, estimate: estimate)
    end
  end

  @spec get_current_user(%Conn{assigns: %{current_user: %User{}}}) :: %User{}
  def get_current_user(conn) do
    conn.assigns.current_user
  end
end
