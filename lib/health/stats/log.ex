defmodule Health.Stats.Log do
  use Ecto.Schema
  import Ecto.Changeset

  schema "log" do
    field :date, :utc_datetime
    field :weight, :integer
    belongs_to :user, Health.Users.User

    timestamps()
  end

  @doc false
  def changeset(log, attrs) do
    log
    |> cast(attrs, [:weight, :date, :user_id])
    |> validate_required([:weight, :date, :user_id])
  end
end
