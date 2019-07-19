defmodule Health.Routine do
  @moduledoc """
  The Routine context, including exercises
  """
  alias Ecto.Changeset
  alias Health.Repo
  alias Health.Routine.Exercise
  import Ecto.Query, warn: false

  @spec list_exercises :: [%Exercise{}]
  def list_exercises do
    Exercise
    |> Repo.all()
  end

  @spec find_exercise(integer) :: %Exercise{} | :error
  def find_exercise(id) do
    Exercise
    |> Repo.get!(id)
  end

  @spec create_exercise(map) :: {:ok, %Exercise{}} | {:error, %Changeset{}}
  def create_exercise(attrs \\ %{}) do
    %Exercise{}
    |> Exercise.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_exercise(%Exercise{}, map) :: {:ok, %Exercise{}} | {:error, %Changeset{}}
  def update_exercise(%Exercise{} = exercise, attrs) do
    exercise
    |> Exercise.changeset(attrs)
    |> Repo.update()
  end

  @spec destroy_exercise(%Exercise{}) :: {:ok, %Exercise{}} | {:error, %Ecto.Changeset{}}
  def destroy_exercise(%Exercise{} = exercise) do
    Repo.delete(exercise)
  end

  @spec change_exercise(Health.Routine.Exercise.t()) :: Ecto.Changeset.t()
  def change_exercise(%Exercise{} = exercise) do
    Exercise.changeset(exercise, %{})
  end
end
