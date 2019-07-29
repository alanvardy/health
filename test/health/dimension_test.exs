defmodule Health.DimensionTest do
  @moduledoc false
  use Health.DataCase, async: true
  import Health.Factory
  alias Health.Dimension
  alias Health.Dimension.Measurement

  describe "measurements" do
    test "list_measurements/0 returns all measurements" do
      user = insert(:user)
      measurement = [insert(:measurement, user: user)]
      measurement2 = Dimension.list_measurements(user)
      assert remove_user(measurement) == remove_user(measurement2)
    end

    test "list_measurements/0 returns only a the logged in users measurements" do
      user = insert(:user)
      user2 = insert(:user, email: "another@email.com")
      measurement = [insert(:measurement, user: user)]
      measurement2 = [insert(:measurement, user: user2)]

      assert remove_user(measurement) == remove_user(Dimension.list_measurements(user))
      assert remove_user(measurement2) == remove_user(Dimension.list_measurements(user2))
    end

    test "get_measurement!/1 returns the measurement with given id" do
      measurement = insert(:measurement)
      measurement2 = Dimension.get_measurement!(measurement.id)
      assert remove_user(measurement) == remove_user(measurement2)
    end

    test "create_measurement/1 with valid data creates a measurement" do
      user = insert(:user)
      measurement_params = params_for(:measurement, user: user)

      assert {:ok, %Measurement{} = measurement} =
               Dimension.create_measurement(measurement_params)

      assert measurement.buttocks == measurement_params.buttocks
      assert measurement.chest == measurement_params.chest
      assert measurement.comment == measurement_params.comment
      assert measurement.date == measurement_params.date
      assert measurement.left_bicep == measurement_params.left_bicep
      assert measurement.left_thigh == measurement_params.left_thigh
      assert measurement.right_bicep == measurement_params.right_bicep
      assert measurement.right_thigh == measurement_params.right_thigh
      assert measurement.waist == measurement_params.waist
      assert measurement.user_id == measurement_params.user_id
    end

    test "create_measurement/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Dimension.create_measurement(%{date: nil})
    end

    test "update_measurement/2 with valid data updates the measurement" do
      measurement = insert(:measurement)

      assert {:ok, %Measurement{} = measurement2} =
               Dimension.update_measurement(measurement, %{left_bicep: 50})

      assert measurement2.left_bicep == 50
      assert measurement2.buttocks == measurement.buttocks
      assert measurement2.chest == measurement.chest
      assert measurement2.comment == measurement.comment
      assert measurement2.date == measurement.date
      assert measurement2.left_thigh == measurement.left_thigh
      assert measurement2.right_bicep == measurement.right_bicep
      assert measurement2.right_thigh == measurement.right_thigh
      assert measurement2.waist == measurement.waist
    end

    test "update_measurement/2 with invalid data returns error changeset" do
      measurement = insert(:measurement)

      assert {:error, %Ecto.Changeset{}} =
               Dimension.update_measurement(measurement, params_for(:measurement, left_bicep: 0))

      measurement2 = Dimension.get_measurement!(measurement.id)
      assert remove_user(measurement) == remove_user(measurement2)
    end

    test "delete_measurement/1 deletes the measurement" do
      measurement = insert(:measurement)
      assert {:ok, %Measurement{}} = Dimension.delete_measurement(measurement)
      assert_raise Ecto.NoResultsError, fn -> Dimension.get_measurement!(measurement.id) end
    end

    test "change_measurement/1 returns a measurement changeset" do
      measurement = build(:measurement)
      assert %Ecto.Changeset{} = Dimension.change_measurement(measurement)
    end

    defp remove_user([measurement]), do: [%Measurement{measurement | user: nil}]
    defp remove_user(measurement), do: %Measurement{measurement | user: nil}
  end
end
