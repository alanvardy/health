defmodule Health.Routine.Exercise do
  @moduledoc """
  An Exercise
  """
  alias Health.ExercisePolicy
  use Ecto.Schema
  import Ecto.Changeset

  schema "exercises" do
    field :name, :string
    field :description, :string
    field :difficulty, :integer

    timestamps()
  end

  defdelegate authorize(action, user, params), to: ExercisePolicy

  @doc false
  @spec changeset(struct(), map()) :: %Ecto.Changeset{}
  def changeset(exercise, attrs) do
    exercise
    |> cast(attrs, [:name, :description, :difficulty])
    |> validate_required([:name, :description, :difficulty])
    |> validate_number(:difficulty, greater_than: 0, less_than: 11)
  end
end
