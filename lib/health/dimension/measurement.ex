defmodule Health.Dimension.Measurement do
  @moduledoc """
  Body measurements
  """
  alias Health.MeasurementPolicy
  use Ecto.Schema
  import Ecto.Changeset

  schema "measurements" do
    field :buttocks, :float
    field :chest, :float
    field :comment, :string
    field :date, :date
    field :left_bicep, :float
    field :left_thigh, :float
    field :right_bicep, :float
    field :right_thigh, :float
    field :waist, :float
    belongs_to :user, Health.Account.User

    timestamps()
  end

  defdelegate authorize(action, user, params), to: MeasurementPolicy

  @doc false
  def changeset(measurement, attrs) do
    measurement
    |> cast(attrs, [
      :date,
      :right_bicep,
      :left_bicep,
      :right_thigh,
      :left_thigh,
      :buttocks,
      :chest,
      :waist,
      :comment,
      :user_id
    ])
    |> validate_required([
      :date,
      :right_bicep,
      :left_bicep,
      :right_thigh,
      :left_thigh,
      :buttocks,
      :chest,
      :waist,
      :user_id
    ])
    |> validate_number(:right_bicep, greater_than: 1, less_than: 400)
    |> validate_number(:left_bicep, greater_than: 1, less_than: 400)
    |> validate_number(:right_thigh, greater_than: 1, less_than: 400)
    |> validate_number(:left_thigh, greater_than: 1, less_than: 400)
    |> validate_number(:buttocks, greater_than: 1, less_than: 400)
    |> validate_number(:chest, greater_than: 1, less_than: 400)
    |> validate_number(:waist, greater_than: 1, less_than: 400)
    |> validate_length(:comment, max: 255)
  end
end
