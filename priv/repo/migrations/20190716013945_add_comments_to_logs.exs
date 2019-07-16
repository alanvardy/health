defmodule Health.Repo.Migrations.AddCommentsToLogs do
  use Ecto.Migration

  def change do
    alter table("logs") do
      add :comment, :string
    end
  end
end
