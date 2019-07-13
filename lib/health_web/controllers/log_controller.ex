defmodule HealthWeb.LogController do
  use HealthWeb, :controller
  alias Health.Stats
  alias Health.Stats.{Calculations, Log}

  action_fallback HealthWeb.FallbackController

  def index(conn, _params) do
    user = get_current_user(conn)
    logs = Stats.list_logs(user)
    log = %Log{}
    changeset = Stats.change_log(log)
    trends = Calculations.weight_trend(logs)

    with :ok <- Bodyguard.permit(Stats, :index, user, Log) do
      render(conn, "index.html", logs: logs, trends: trends, changeset: changeset)
    end
  end

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
            trends = Calculations.weight_trend(logs)
            conn
            |> put_flash(:error, "Your log could not be created")
            |> render("index.html", changeset: changeset, logs: logs, trends: trends)
          end
      end
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
end
