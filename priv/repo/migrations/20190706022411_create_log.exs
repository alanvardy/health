defmodule Health.Repo.Migrations.CreateLog do
  use Ecto.Migration

  def change do
    create table(:log) do
      add :weight, :integer
      add :date, :utc_datetime
      add :user_id, references(:users, on_delete: :delete_all)

      timestamps()
    end

    create index(:log, [:user_id])
  end
end
