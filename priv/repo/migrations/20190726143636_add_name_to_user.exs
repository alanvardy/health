defmodule Health.Repo.Migrations.AddNameToUser do
  @moduledoc false
  use Ecto.Migration

  def change do
    alter table("users") do
      add :name, :string
    end
  end
end
