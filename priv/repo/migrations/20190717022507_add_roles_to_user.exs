defmodule Health.Repo.Migrations.AddRolesToUser do
  use Ecto.Migration

  def change do
    alter table("users") do
      add :roles, :integer, default: 0
    end
  end
end
