defmodule HealthWeb.ExerciseControllerTest do
  @moduledoc false
  use HealthWeb.ConnCase, async: true

  test "must be logged in to view", %{conn: conn} do
    conn = get(conn, Routes.exercise_path(conn, :index))

    assert redirected_to(conn) == Routes.pow_session_path(conn, :new, request_path: "/exercises")
  end

  test "index", %{conn: conn} do
    exercise = insert(:exercise)

    conn = conn
    |> insert_and_log_in(:user)
    |> get(Routes.exercise_path(conn, :index))

    assert html_response(conn, 200) =~ "Exercises"
    assert html_response(conn, 200) =~ exercise.name
  end

  test "show", %{conn: conn} do
    exercise = insert(:exercise)

    conn =
      conn
      |> insert_and_log_in(:user)
      |> get(Routes.exercise_path(conn, :show, exercise))

    assert html_response(conn, 200) =~ exercise.name
  end

  test "new", %{conn: conn} do
    conn =
      conn
      |> insert_and_log_in(:user)
      |> get(Routes.exercise_path(conn, :new))

    assert html_response(conn, 200) =~ "<form"
  end

  test "create valid", %{conn: conn} do
    exercise_params = params_for(:exercise)

    conn =
      conn
      |> insert_and_log_in(:user)
      |> post(Routes.exercise_path(conn, :create), exercise: exercise_params)

    assert redirected_to(conn) == Routes.exercise_path(conn, :index)
    assert Map.has_key?(get_flash(conn), "success")
  end

  test "create invalid", %{conn: conn} do
    invalid_params = %{}

    conn =
      conn
      |> insert_and_log_in(:user)
      |> post(Routes.exercise_path(conn, :create), exercise: invalid_params)

    assert html_response(conn, 200) =~ "<form"
    assert html_response(conn, 200) =~ "can&#39;t be blank"
    assert Map.has_key?(get_flash(conn), "danger")
  end

  test "edit", %{conn: conn} do
    exercise = insert(:exercise)

    conn =
      conn
      |> insert_and_log_in(:user)
      |> get(Routes.exercise_path(conn, :edit, exercise))

    assert html_response(conn, 200) =~ "<form"
    assert html_response(conn, 200) =~ exercise.name
  end

  test "update valid", %{conn: conn} do
    exercise = insert(:exercise)
    exercise_params = %{name: "Test Exercise"}

    conn =
      conn
      |> insert_and_log_in(:user)
      |> patch(Routes.exercise_path(conn, :update, exercise), exercise: exercise_params)

    assert redirected_to(conn) == Routes.exercise_path(conn, :index)
    assert Map.has_key?(get_flash(conn), "success")
  end

  test "update invalid", %{conn: conn} do
    exercise = insert(:exercise)
    invalid_params = %{name: ""}

    conn =
      conn
      |> insert_and_log_in(:user)
      |> patch(Routes.exercise_path(conn, :update, exercise), exercise: invalid_params)

    assert html_response(conn, 200) =~ "<form"
    assert html_response(conn, 200) =~ "can&#39;t be blank"
    assert Map.has_key?(get_flash(conn), "danger")
  end

  test "destroy", %{conn: conn} do
    exercise = insert(:exercise)

    conn =
      conn
      |> insert_and_log_in(:user)
      |> delete(Routes.exercise_path(conn, :delete, exercise))

    assert redirected_to(conn) == Routes.exercise_path(conn, :index)
    assert Map.has_key?(get_flash(conn), "success")
  end
end
