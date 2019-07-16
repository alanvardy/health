defmodule Health.Exercise do
  @moduledoc """
  An Exercise
  """
  alias Health.{Exercise, Repo}
  use Ecto.Schema
  import Ecto.Changeset

  schema "exercises" do
    field :name, :string
    field :description, :string
    field :difficulty, :integer

    timestamps()
  end

  @doc false
  @spec changeset(struct(), map()) :: %Ecto.Changeset{}
  def changeset(exercise, attrs) do
    exercise
    |> cast(attrs, [:name, :description, :difficulty])
    |> validate_required([:name, :description, :difficulty])
    |> validate_number(:difficulty, greater_than: 0, less_than: 11)
  end

  @spec all :: [%Exercise{}]
  def all do
    Exercise |> Repo.all
  end

  @spec find(integer) :: %Exercise{} | :error
  def find(id) do
    Exercise |> Repo.get!(id)
  end

  @spec destroy(%Exercise{}) :: {:ok, %Exercise{}} | {:error, %Ecto.Changeset{}}
  def destroy(%Exercise{} = exercise) do
    Repo.delete(exercise)
  end

end
