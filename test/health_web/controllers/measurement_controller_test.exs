defmodule HealthWeb.MeasurementControllerTest do
  @moduledoc false
  use HealthWeb.ConnCase, async: true

  describe "index" do
    test "Doesn't list measurements when not logged in", %{conn: conn} do
      conn = get(conn, Routes.measurement_path(conn, :index))

      assert redirected_to(conn) ==
               Routes.pow_session_path(conn, :new, request_path: "/measurements")
    end

    test "lists all measurements when logged in", %{conn: conn} do
      user = insert(:user)
      insert(:measurement, user: user)

      conn =
        conn
        |> log_in(user)
        |> get(Routes.measurement_path(conn, :index))

      assert html_response(conn, 200) =~ "Listing Measurements"
    end

    test "lists all measurements when logged in but no measurements", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> log_in(user)
        |> get(Routes.measurement_path(conn, :index))

      assert html_response(conn, 200) =~ "Listing Measurements"
    end
  end

  describe "new measurement" do
    test "Doesn't render form when not logged in", %{conn: conn} do
      conn = get(conn, Routes.measurement_path(conn, :new))

      assert redirected_to(conn) ==
               Routes.pow_session_path(conn, :new, request_path: "/measurements/new")
    end

    test "renders form when logged in", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> log_in(user)
        |> get(Routes.measurement_path(conn, :new))

      assert html_response(conn, 200) =~ "New Measurement"
    end
  end

  describe "create measurement" do
    test "Doesn't create when not logged in", %{conn: conn} do
      conn =
        post(conn, Routes.measurement_path(conn, :create), measurement: params_for(:measurement))

      assert redirected_to(conn) ==
               Routes.pow_session_path(conn, :new, request_path: "/measurements")
    end

    test "redirects to show when data is valid and logged in", %{conn: conn} do
      user = insert(:user)

      conn2 =
        conn
        |> log_in(user)
        |> post(Routes.measurement_path(conn, :create), measurement: params_for(:measurement))

      assert %{id: id} = redirected_params(conn2)
      assert redirected_to(conn2) == Routes.measurement_path(conn2, :show, id)

      conn3 =
        conn
        |> log_in(user)
        |> get(Routes.measurement_path(conn, :show, id))

      assert html_response(conn3, 200) =~ "Show Measurement"
    end

    test "renders errors when logged in and data is invalid", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> log_in(user)
        |> post(Routes.measurement_path(conn, :create),
          measurement: params_for(:measurement, date: nil)
        )

      assert html_response(conn, 200)
    end
  end

  # describe "edit measurement" do
  #   setup [:create_measurement]

  #   test "renders form for editing chosen measurement", %{conn: conn, measurement: measurement} do
  #     conn = get(conn, Routes.measurement_path(conn, :edit, measurement))
  #     assert html_response(conn, 200) =~ "Edit Measurement"
  #   end
  # end

  # describe "update measurement" do
  #   setup [:create_measurement]

  #   test "redirects when data is valid", %{conn: conn, measurement: measurement} do
  #     conn =
  #       put(conn, Routes.measurement_path(conn, :update, measurement), measurement: @update_attrs)

  #     assert redirected_to(conn) == Routes.measurement_path(conn, :show, measurement)

  #     conn = get(conn, Routes.measurement_path(conn, :show, measurement))
  #     assert html_response(conn, 200) =~ "some updated comment"
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, measurement: measurement} do
  #     conn =
  #       put(conn, Routes.measurement_path(conn, :update, measurement), measurement: @invalid_attrs)

  #     assert html_response(conn, 200) =~ "Edit Measurement"
  #   end
  # end

  # describe "delete measurement" do
  #   setup [:create_measurement]

  #   test "deletes chosen measurement", %{conn: conn, measurement: measurement} do
  #     conn = delete(conn, Routes.measurement_path(conn, :delete, measurement))
  #     assert redirected_to(conn) == Routes.measurement_path(conn, :index)

  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.measurement_path(conn, :show, measurement))
  #     end
  #   end
  # end
end
