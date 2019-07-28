defmodule HealthWeb.MeasurementController do
  use HealthWeb, :controller

  alias Health.Account.User
  alias Health.Dimension
  alias Health.Dimension.Measurement
  alias Plug.Conn

  action_fallback HealthWeb.FallbackController

  @spec index(Plug.Conn.t(), any) :: {:error, any} | Plug.Conn.t()
  def index(conn, _params) do
    user = get_current_user(conn)
    measurements = Dimension.list_measurements()

    with :ok <- Bodyguard.permit(Measurement, :index, user, %Measurement{}) do
      render(conn, "index.html", measurements: measurements)
    end
  end

  @spec new(Plug.Conn.t(), any) :: Plug.Conn.t()
  def new(conn, _params) do
    user = get_current_user(conn)
    changeset = Dimension.change_measurement(%Measurement{})

    with :ok <- Bodyguard.permit(Measurement, :new, user, %Measurement{}) do
      render(conn, "new.html", changeset: changeset)
    end
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{measurement: measurement_params}) do
    user = get_current_user(conn)
    measurement_params = Map.put(measurement_params, :user_id, user.id)

    with :ok <- Bodyguard.permit(Measurement, :create, user, %Measurement{}) do
      case Dimension.create_measurement(measurement_params) do
        {:ok, measurement} ->
          conn
          |> put_flash(:info, "Measurement created successfully.")
          |> redirect(to: Routes.measurement_path(conn, :show, measurement))

        {:error, %Ecto.Changeset{} = changeset} ->
          with :ok <- Bodyguard.permit(Measurement, :new, user, %Measurement{}) do
            render(conn, "new.html", changeset: changeset)
          end
      end
    end
  end

  @spec show(Plug.Conn.t(), map) :: Plug.Conn.t()
  def show(conn, %{"id" => id}) do
    user = get_current_user(conn)
    measurement = Dimension.get_measurement!(id)

    with :ok <- Bodyguard.permit(Measurement, :show, user, measurement) do
      render(conn, "show.html", measurement: measurement)
    end
  end

  @spec edit(Plug.Conn.t(), map) :: Plug.Conn.t()
  def edit(conn, %{"id" => id}) do
    user = get_current_user(conn)
    measurement = Dimension.get_measurement!(id)
    changeset = Dimension.change_measurement(measurement)

    with :ok <- Bodyguard.permit(Measurement, :edit, user, measurement) do
      render(conn, "edit.html", measurement: measurement, changeset: changeset)
    end
  end

  @spec update(Plug.Conn.t(), map) :: Plug.Conn.t()
  def update(conn, %{"id" => id, "measurement" => measurement_params}) do
    user = get_current_user(conn)
    measurement = Dimension.get_measurement!(id)

    with :ok <- Bodyguard.permit(Measurement, :update, user, measurement) do
      case Dimension.update_measurement(measurement, measurement_params) do
        {:ok, measurement} ->
          conn
          |> put_flash(:info, "Measurement updated successfully.")
          |> redirect(to: Routes.measurement_path(conn, :show, measurement))

        {:error, %Ecto.Changeset{} = changeset} ->
          with :ok <- Bodyguard.permit(Measurement, :edit, user, measurement) do
            render(conn, "edit.html", measurement: measurement, changeset: changeset)
          end
      end
    end
  end

  @spec delete(Plug.Conn.t(), map) :: Plug.Conn.t()
  def delete(conn, %{"id" => id}) do
    user = get_current_user(conn)
    measurement = Dimension.get_measurement!(id)

    with :ok <- Bodyguard.permit(Measurement, :delete, user, measurement) do
      {:ok, _measurement} = Dimension.delete_measurement(measurement)

      conn
      |> put_flash(:info, "Measurement deleted successfully.")
      |> redirect(to: Routes.measurement_path(conn, :index))
    end
  end

  @spec get_current_user(%Conn{assigns: %{current_user: %User{}}}) :: %User{}
  def get_current_user(conn) do
    conn.assigns.current_user
  end
end
