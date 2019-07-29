defmodule Health.MeasurementPolicy do
  @moduledoc "Permissions for all measurement related items"

  alias Health.Account.User
  alias Health.Dimension.Measurement
  @behaviour Bodyguard.Policy

  # Users can access their own Measurements
  @spec authorize(any, any, any) :: boolean
  def authorize(action, %User{id: user_id}, %Measurement{user_id: user_id})
      when action in [:show, :edit, :update, :delete],
      do: true

  # Can view their measurements and create new ones
  def authorize(action, %User{}, %Measurement{})
      when action in [:index, :new, :create],
      do: true

  # Catch-all: deny everything else
  def authorize(_, _, _), do: false
end
