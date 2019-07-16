defmodule HealthWeb.ExerciseController do
  use HealthWeb, :controller
  alias Health.Account.User
  alias Health.Exercise
  alias Plug.Conn

  action_fallback HealthWeb.FallbackController

  @spec index(%Conn{assigns: %{current_user: %User{}}}, map) :: {:error, any} | %Conn{}
  def index(conn, _params) do
    user = get_current_user(conn)

    exercises = Exercise.all()

    with :ok <- Bodyguard.permit(Health.Policies.Exercise, :index, user, Exercise) do
      render(conn, "index.html", exercises: exercises)
    end
  end

  @spec new(%Conn{assigns: %{current_user: %User{}}}, map) :: {:error, any} | %Conn{}
  def new(conn, _params) do
    user = get_current_user(conn)

    exercise = %Exercise{}
    changeset = Exercise.changeset(exercise, %{})

    with :ok <- Bodyguard.permit(Health.Policies.Exercise, :new, user, exercise) do
      render(conn, "new.html", exercise: exercise, changeset: changeset)
    end
  end

  @spec create(%Conn{assigns: %{current_user: %User{}}}, map) :: {:error, any} | %Conn{}
  def create(conn, %{exercise: params}) do
    user = get_current_user(conn)

    exercise = %Exercise{}

    with :ok <- Bodyguard.permit(Health.Policies.Exercise, :create, user, exercise) do
      exercise
      |> Exercise.changeset(params)
      |> Health.Repo.insert()
      |> case do
        {:ok, _exercise} ->
          conn
          |> put_flash(:success, "Exercise created successfully.")
          |> redirect(to: Routes.exercise_path(conn, :index))
        {:error, %Ecto.Changeset{} = changeset} ->
          conn
          |> put_flash(:danger, "Unable to save exercise. Fix any errors below and try again.")
          |> render("new.html", changeset: changeset)
      end
    end
  end

  @spec edit(%Conn{assigns: %{current_user: %User{}}}, map) :: {:error, any} | %Conn{}
  def edit(conn, %{id: id}) do
    user = get_current_user(conn)

    exercise = Exercise.find(id)
    changeset = Exercise.changeset(exercise, %{})

    with :ok <- Bodyguard.permit(Health.Policies.Exercise, :edit, user, exercise) do
      render(conn, "edit.html", changeset: changeset, exercise: exercise)
    end
  end

  @spec update(%Conn{assigns: %{current_user: %User{}}}, map) :: {:error, any} | %Conn{}
  def update(conn, %{id: id, exercise: params}) do
    user = get_current_user(conn)

    exercise = Exercise.find(id)

    with :ok <- Bodyguard.permit(Health.Policies.Exercise, :update, user, exercise) do
      exercise
      |> Exercise.changeset(params)
      |> Health.Repo.update()
      |> case do
        {:ok, _exercise} ->
          conn
          |> put_flash(:success, "Exercise updated successfully.")
          |> redirect(to: Routes.exercise_path(conn, :index))
        {:error, %Ecto.Changeset{} = changeset} ->
          conn
          |> put_flash(:danger, "Unable to update exercise. Fix any errors below and try again.")
          |> render("edit.html", changeset: changeset, exercise: exercise)
      end
    end
  end

  @spec show(%Conn{assigns: %{current_user: %User{}}}, map) :: {:error, any} | %Conn{}
  def show(conn, %{id: id}) do
    user = get_current_user(conn)

    exercise = Exercise.find(id)

    with :ok <- Bodyguard.permit(Health.Policies.Exercise, :show, user, exercise) do
      render(conn, "show.html", exercise: exercise)
    end
  end

  @spec delete(%Conn{assigns: %{current_user: %User{}}}, map) :: {:error, any} | %Conn{}
  def delete(conn, %{id: id}) do
    user = get_current_user(conn)

    exercise = Exercise.find(id)

    with :ok <- Bodyguard.permit(Health.Policies.Exercise, :delete, user, exercise) do
      case Exercise.destroy(exercise) do
      {:ok, _exercise} ->
        conn
        |> put_flash(:success, "Exercise deleted successfully.")
        |> redirect(to: Routes.exercise_path(conn, :index))
      {:error, _changeset} ->
        conn
        |> put_flash(:danger, "Unable to delete exercise.")
        |> redirect(to: Routes.exercise_path(conn, :index))
      end
    end
  end

  @spec get_current_user(%Conn{assigns: %{current_user: %User{}}}) :: %User{}
  def get_current_user(conn) do
    conn.assigns.current_user
  end

end
