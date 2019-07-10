defmodule Health.Repo.Migrations.ChangeLogDatetimeToDate do
  use Ecto.Migration

  def change do
    alter table("log") do
      modify :date, :date
    end

    rename table("log"), to: table("logs")
  end
end
