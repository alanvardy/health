defmodule Health.Account.EditableUser do
  @moduledoc """
  Schema and changeset to allow admin to edit users without pow getting in the way
  For regular usage, use Health.Account.User
  """

  alias Health.EditableUserPolicy
  use Ecto.Schema
  # import Ecto.Changeset

  @type t :: %__MODULE__{
          id: integer,
          email: String.t(),
          password_hash: String.t(),
          current_password: String.t(),
          password: String.t(),
          confirm_password: String.t()
        }

  schema "users" do
    has_many :logs, Health.Weight.Log, foreign_key: :user_id
    has_many :measurements, Health.Dimension.Measurement, foreign_key: :user_id
    field :roles, :integer
    field :name, :string

    # pow attributes
    field :email, :string
    field :password_hash, :string
    field :current_password, :string, virtual: true
    field :password, :string, virtual: true
    field :confirm_password, :string, virtual: true

    timestamps()
  end

  defdelegate authorize(action, user, params), to: EditableUserPolicy

  # Pow function
  @spec pow_user_id_field :: :email
  def pow_user_id_field, do: :email

  @spec changeset(%Health.Account.EditableUser{} | %Ecto.Changeset{}, map()) :: %Ecto.Changeset{}
  def changeset(user, attrs) do
    user
    |> Ecto.Changeset.cast(attrs, [:roles, :name])
    |> Ecto.Changeset.validate_required([:roles, :name])
    |> Ecto.Changeset.validate_number(:roles, greater_than_or_equal_to: 0, less_than: 11)
  end
end
