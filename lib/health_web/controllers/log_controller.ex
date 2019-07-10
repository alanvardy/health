defmodule HealthWeb.LogController do
  use HealthWeb, :controller
  alias Health.Stats
  alias Health.Stats.Log

  action_fallback HealthWeb.FallbackController

  def index(conn, _params) do
    user = get_current_user(conn)
    logs = Stats.list_logs(user)

    with :ok <- Bodyguard.permit(Stats, :index, user, Log) do
      render(conn, "index.html", logs: logs)
    end
  end

  def new(conn, _params) do
    user = get_current_user(conn)
    log = %Log{}

    with :ok <- Bodyguard.permit(Stats, :new, user, log) do
      changeset = Stats.change_log(log)
      render(conn, "new.html", changeset: changeset)
    end
  end

  def create(conn, %{log: log_params}) do
    user = get_current_user(conn)
    log = %Log{}
    log_params = Map.put(log_params, :user_id, user.id)

    with :ok <- Bodyguard.permit(Stats, :new, user, log) do
      case Stats.create_log(log_params) do
        {:ok, log} ->
          conn
          |> put_flash(:info, "Log created successfully.")
          |> redirect(to: Routes.log_path(conn, :show, log))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end
  end

  def show(conn, %{"id" => id}) do
    user = get_current_user(conn)
    log = Stats.get_log!(id)

    with :ok <- Bodyguard.permit(Stats, :show, user, log) do
      render(conn, "show.html", log: log)
    end
  end

  def edit(conn, %{"id" => id}) do
    user = get_current_user(conn)
    log = Stats.get_log!(id)
    changeset = Stats.change_log(log)

    with :ok <- Bodyguard.permit(Stats, :edit, user, log) do
      render(conn, "edit.html", log: log, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "log" => log_params}) do
    user = get_current_user(conn)
    log = Stats.get_log!(id)

    with :ok <- Bodyguard.permit(Stats, :update, user, log) do
      case Stats.update_log(log, log_params) do
        {:ok, log} ->
          conn
          |> put_flash(:info, "Log updated successfully.")
          |> redirect(to: Routes.log_path(conn, :show, log))

        {:error, %Ecto.Changeset{} = changeset} ->
          render(conn, "edit.html", log: log, changeset: changeset)
      end
    end
  end

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

  def get_current_user(conn) do
    conn.assigns.current_user
  end

  def get_current_action(conn) do
    conn.private.phoenix_action
  end
end
