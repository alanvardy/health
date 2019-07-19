defmodule Health.Account.Admin do
  @moduledoc "Schema and changeset to allow admin to edit users without pow getting in the way"
  alias Health.AdminPolicy
  use Ecto.Schema
  use Pow.Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    has_many :logs, Health.Weight.Log, foreign_key: :user_id
    field :roles, :integer
    field :email, :string
    pow_user_fields()

    timestamps()
  end

  defdelegate authorize(action, user, params), to: AdminPolicy

  @spec changeset(any, map) :: Ecto.Changeset.t()
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:roles])
    |> validate_required([:roles])
    |> validate_number(:roles, greater_than_or_equal_to: 0, less_than: 11)
  end
end
