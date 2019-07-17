defmodule HealthWeb.ExerciseControllerTest do
  @moduledoc false
  use HealthWeb.ConnCase, async: true

  test "must be logged in to view", %{conn: conn} do
    conn = get(conn, Routes.exercise_path(conn, :index))

    assert redirected_to(conn) == Routes.pow_session_path(conn, :new, request_path: "/exercises")
  end

  test "index", %{conn: conn} do
    conn = conn |> log_in(insert(:user))
    exercise = insert(:exercise)

    conn = get(conn, Routes.exercise_path(conn, :index))

    assert html_response(conn, 200) =~ "Exercises"
    assert html_response(conn, 200) =~ exercise.name
  end

  test "show", %{conn: conn} do
    conn = conn |> log_in(insert(:user))
    exercise = insert(:exercise)

    conn = get(conn, Routes.exercise_path(conn, :show, exercise))

    assert html_response(conn, 200) =~ exercise.name
  end

  test "new", %{conn: conn} do
    conn = conn |> log_in(insert(:user))

    conn = get(conn, Routes.exercise_path(conn, :new))

    assert html_response(conn, 200) =~ "<form"
  end

  test "create valid", %{conn: conn} do
    conn = conn |> log_in(insert(:user))

    exercise_params = params_for(:exercise)
    conn = post(conn, Routes.exercise_path(conn, :create), exercise: exercise_params)

    assert redirected_to(conn) == Routes.exercise_path(conn, :index)
    assert Map.has_key?(get_flash(conn), "success")
  end

  test "create invalid", %{conn: conn} do
    conn = conn |> log_in(insert(:user))

    invalid_params = %{}
    conn = post(conn, Routes.exercise_path(conn, :create), exercise: invalid_params)

    assert html_response(conn, 200) =~ "<form"
    assert html_response(conn, 200) =~ "can&#39;t be blank"
    assert Map.has_key?(get_flash(conn), "danger")
  end

  test "edit", %{conn: conn} do
    conn = conn |> log_in(insert(:user))
    exercise = insert(:exercise)

    conn = get(conn, Routes.exercise_path(conn, :edit, exercise))

    assert html_response(conn, 200) =~ "<form"
    assert html_response(conn, 200) =~ exercise.name
  end

  test "update valid", %{conn: conn} do
    conn = conn |> log_in(insert(:user))
    exercise = insert(:exercise)

    exercise_params = %{name: "Test Exercise"}
    conn = patch(conn, Routes.exercise_path(conn, :update, exercise), exercise: exercise_params)

    assert redirected_to(conn) == Routes.exercise_path(conn, :index)
    assert Map.has_key?(get_flash(conn), "success")
  end

  test "update invalid", %{conn: conn} do
    conn = conn |> log_in(insert(:user))
    exercise = insert(:exercise)

    invalid_params = %{name: ""}
    conn = patch(conn, Routes.exercise_path(conn, :update, exercise), exercise: invalid_params)

    assert html_response(conn, 200) =~ "<form"
    assert html_response(conn, 200) =~ "can&#39;t be blank"
    assert Map.has_key?(get_flash(conn), "danger")
  end

  test "destroy", %{conn: conn} do
    conn = conn |> log_in(insert(:user))
    exercise = insert(:exercise)

    conn = delete(conn, Routes.exercise_path(conn, :delete, exercise))

    assert redirected_to(conn) == Routes.exercise_path(conn, :index)
    assert Map.has_key?(get_flash(conn), "success")
  end
end
