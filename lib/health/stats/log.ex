defmodule Health.Stats.Log do
  @moduledoc "Stats log for a user"
  use Ecto.Schema
  import Ecto.Changeset

  schema "logs" do
    field :date, :date
    field :weight, :float
    belongs_to :user, Health.Users.User

    timestamps()
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:weight, :date, :user_id])
    |> validate_required([:weight, :date, :user_id])
    |> validate_number(:weight, greater_than: 1, less_than: 500)
  end
end
