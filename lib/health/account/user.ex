defmodule Health.Account.User do
  @moduledoc """
    Use this Account for all cases except when admin needs to edit attributes
  """
  alias Health.UserPolicy
  use Ecto.Schema
  use Pow.Ecto.Schema

  @type t :: %__MODULE__{
          roles: integer,
          email: String.t()
        }

  schema "users" do
    has_many :logs, Health.Weight.Log
    field :roles, :integer
    pow_user_fields()

    timestamps()
  end

  defdelegate authorize(action, user, params), to: UserPolicy

  # For additional attributes we can use this method
  # def changeset(user_or_changeset, attrs) do
  #   user_or_changeset
  #   |> pow_changeset(attrs)
  #   |> Ecto.Changeset.cast(attrs, [:custom])
  #   |> Ecto.Changeset.validate_required([:custom])
  # end

  # Any pow password works in development mode
  # coveralls-ignore-start
  @spec verify_password(String.t(), String.t()) :: boolean()
  def verify_password(user, password) do
    case Application.get_env(:health, :env) do
      :dev -> true
      _ -> pow_verify_password(user, password)
    end
  end

  # coveralls-ignore-stop
end
