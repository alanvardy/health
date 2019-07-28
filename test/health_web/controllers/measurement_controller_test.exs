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

  describe "edit measurement" do
    test "doesn't render form for editing chosen measurement when not logged in", %{conn: conn} do
      measurement = insert(:measurement)
      conn = get(conn, Routes.measurement_path(conn, :edit, measurement))

      assert redirected_to(conn) ==
               Routes.pow_session_path(conn, :new,
                 request_path: "/measurements/#{measurement.id}/edit"
               )
    end

    test "doesn't render form for editing chosen measurement when different user", %{conn: conn} do
      user = insert(:user)
      measurement = insert(:measurement, user: user)
      user2 = insert(:user, email: "something@else.com")

      conn =
        conn
        |> log_in(user2)
        |> get(Routes.measurement_path(conn, :edit, measurement))

      assert response(conn, 403) =~ "Forbidden"
    end

    test "renders form for editing chosen measurement when same user", %{conn: conn} do
      user = insert(:user)
      measurement = insert(:measurement, user: user)

      conn =
        conn
        |> log_in(user)
        |> get(Routes.measurement_path(conn, :edit, measurement))

      assert html_response(conn, 200) =~ "Edit Measurement"
    end
  end

  describe "update measurement" do
    test "doesn't update when not logged in", %{conn: conn} do
      measurement = insert(:measurement)

      conn =
        conn
        |> put(Routes.measurement_path(conn, :update, measurement),
          measurement: params_for(:measurement)
        )

      assert redirected_to(conn) ==
               Routes.pow_session_path(conn, :new, request_path: "/measurements/#{measurement.id}")
    end

    test "doesn't update when different user", %{conn: conn} do
      user = insert(:user)
      user2 = insert(:user, email: "different@user.com")
      measurement = insert(:measurement, user: user)

      conn =
        conn
        |> log_in(user2)
        |> put(Routes.measurement_path(conn, :update, measurement),
          measurement: params_for(:measurement)
        )

      assert response(conn, 403) =~ "Forbidden"
    end

    test "redirects when data is valid and user is logged in", %{conn: conn} do
      user = insert(:user)
      measurement = insert(:measurement, user: user)

      conn =
        conn
        |> log_in(user)
        |> put(Routes.measurement_path(conn, :update, measurement),
          measurement: params_for(:measurement, right_bicep: 150)
        )

      assert redirected_to(conn) == Routes.measurement_path(conn, :show, measurement)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      user = insert(:user)
      measurement = insert(:measurement, user: user)

      conn =
        conn
        |> log_in(user)
        |> put(Routes.measurement_path(conn, :update, measurement),
          measurement: params_for(:measurement, right_bicep: -1)
        )

      assert html_response(conn, 200) =~ "Edit Measurement"
    end
  end

  describe "delete measurement" do
    test "cannot delete measurement when not logged in", %{conn: conn} do
      measurement = insert(:measurement)

      conn =
        conn
        |> delete(Routes.measurement_path(conn, :delete, measurement))

      assert redirected_to(conn) ==
               Routes.pow_session_path(conn, :new, request_path: "/measurements/#{measurement.id}")
    end

    test "cannot delete measurement when logged in as a different user", %{conn: conn} do
      user = insert(:user)
      user2 = insert(:user, email: "different@user.com")
      measurement = insert(:measurement, user: user)

      conn =
        conn
        |> log_in(user2)
        |> delete(Routes.measurement_path(conn, :delete, measurement))

      assert response(conn, 403) =~ "Forbidden"
    end

    test "deletes chosen measurement when logged in as measurement's user", %{conn: conn} do
      user = insert(:user)
      measurement = insert(:measurement, user: user)

      conn2 =
        conn
        |> log_in(user)
        |> delete(Routes.measurement_path(conn, :delete, measurement))

      assert redirected_to(conn2) == Routes.measurement_path(conn2, :index)

      conn3 =
        conn
        |> log_in(user)

      assert_error_sent 404, fn ->
        get(conn3, Routes.measurement_path(conn3, :show, measurement))
      end
    end
  end
end
