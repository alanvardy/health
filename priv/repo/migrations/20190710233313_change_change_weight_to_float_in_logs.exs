defmodule Health.Repo.Migrations.ChangeChangeWeightToFloatInLogs do
  use Ecto.Migration

  def change do
    alter table("logs") do
      modify :weight, :float
    end
  end
end
