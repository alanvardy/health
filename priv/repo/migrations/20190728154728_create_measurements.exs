defmodule Health.Repo.Migrations.CreateMeasurements do
  use Ecto.Migration

  def change do
    create table(:measurements) do
      add :date, :date
      add :right_bicep, :float
      add :left_bicep, :float
      add :right_thigh, :float
      add :left_thigh, :float
      add :buttocks, :float
      add :chest, :float
      add :waist, :float
      add :comment, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:measurements, [:user_id])
  end
end
