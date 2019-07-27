defmodule Health.Repo.Migrations.CreateExercises do
  use Ecto.Migration

  def change do
    create table(:exercises) do
      add :name, :string
      add :description, :text

      add :difficulty, :integer

      timestamps()
    end

    create index(:exercises, [:name], unique: true)
  end
end
