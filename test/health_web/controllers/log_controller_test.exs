defmodule HealthWeb.LogControllerTest do
  @moduledoc false
  use HealthWeb.ConnCase

  describe "index" do
    test "doesn't list logs when not logged in", %{conn: conn} do
      conn = get(conn, Routes.log_path(conn, :index))
      assert redirected_to(conn) == Routes.pow_session_path(conn, :new, request_path: "/logs")
    end

    test "lists logs when logged in", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> log_in(user)

      conn = get(conn, Routes.log_path(conn, :index))

      assert html_response(conn, 200) =~ "Listing Log"
    end
  end

  describe "new log" do
    test "doesn't render form when not logged in", %{conn: conn} do
      conn = get(conn, Routes.log_path(conn, :new))
      assert redirected_to(conn) == Routes.pow_session_path(conn, :new, request_path: "/logs/new")
    end

    test "renders form when logged in", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> log_in(user)
        |> get(Routes.log_path(conn, :new))

      assert html_response(conn, 200) =~ "New Log"
    end
  end

  describe "create log" do
    test "doesn't create when not logged in", %{conn: conn} do
      conn = post(conn, Routes.log_path(conn, :create), log: params_for(:log))

      assert redirected_to(conn) == Routes.pow_session_path(conn, :new, request_path: "/logs")
    end

    test "redirects to show when data is valid and logged in", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> log_in(user)
        |> post(Routes.log_path(conn, :create), log: params_for(:log, user_id: user.id))

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.log_path(conn, :show, id)
    end

    test "renders errors when data is invalid and logged in", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> log_in(user)
        |> post(Routes.log_path(conn, :create), log: params_for(:log, weight: nil))

      assert html_response(conn, 200) =~ "New Log"
    end
  end

  describe "show log" do
    test "cannot access show when not logged in", %{conn: conn} do
      log = insert(:log)
      conn = get(conn, Routes.log_path(conn, :show, log))

      assert redirected_to(conn) ==
               Routes.pow_session_path(conn, :new, request_path: "/logs/#{log.id}")
    end

    test "can access show when log belongs to user", %{conn: conn} do
      user = insert(:user)
      log = insert(:log, user: user)

      conn =
        conn
        |> log_in(user)
        |> get(Routes.log_path(conn, :show, log))

      assert html_response(conn, 200) =~ "Show Log"
    end

    test "cannot access show when log belongs to other user", %{conn: conn} do
      user = insert(:user)
      user2 = insert(:user, email: "user2@example.com")
      log = insert(:log, user: user)

      conn =
        conn
        |> log_in(user2)
        |> get(Routes.log_path(conn, :show, log))

      assert response(conn, 403) =~ "Forbidden"
    end
  end

  describe "edit log" do
    test "doesn't render form when not logged in", %{conn: conn} do
      log = insert(:log)
      conn = get(conn, Routes.log_path(conn, :edit, log))

      assert redirected_to(conn) ==
               Routes.pow_session_path(conn, :new, request_path: "/logs/#{log.id}/edit")
    end

    test "renders form for editing chosen log when belongs to user", %{conn: conn} do
      user = insert(:user)
      log = insert(:log, user: user)

      conn =
        conn
        |> log_in(user)
        |> get(Routes.log_path(conn, :edit, log))

      assert html_response(conn, 200) =~ "Edit Log"
    end

    test "doesn't form for editing chosen log when belongs to different user", %{conn: conn} do
      user = insert(:user)
      user2 = insert(:user, email: "seconduser@example.com")
      log = insert(:log, user: user)

      conn =
        conn
        |> log_in(user2)
        |> get(Routes.log_path(conn, :edit, log))

      assert response(conn, 403) =~ "Forbidden"
    end
  end

  describe "update log" do
    test "redirects to log in when not logged in", %{conn: conn} do
      log = insert(:log)
      conn = put(conn, Routes.log_path(conn, :update, log), log: params_for(:log, weight: 235))

      assert redirected_to(conn) ==
               Routes.pow_session_path(conn, :new, request_path: "/logs/#{log.id}")
    end

    test "redirects when data is valid and user is logged in", %{conn: conn} do
      user = insert(:user)
      log = insert(:log, user: user)

      conn =
        conn
        |> log_in(user)
        |> put(Routes.log_path(conn, :update, log), log: params_for(:log, weight: 200))

      assert redirected_to(conn) == Routes.log_path(conn, :show, log)
    end

    test "rejects when data is valid and a different user is logged in", %{conn: conn} do
      user = insert(:user)
      user2 = insert(:user, email: "different@example.com")
      log = insert(:log, user: user)

      conn =
        conn
        |> log_in(user2)
        |> put(Routes.log_path(conn, :update, log), log: params_for(:log, weight: 200))

      assert response(conn, 403) =~ "Forbidden"
    end

    test "renders errors when data is invalid and user is logged in", %{conn: conn} do
      user = insert(:user)
      log = insert(:log, user: user)

      conn =
        conn
        |> log_in(user)
        |> put(Routes.log_path(conn, :update, log), log: params_for(:log, weight: ""))

      assert html_response(conn, 200) =~ "Edit Log"
    end
  end

  describe "delete log" do
    test "redirects to log in when not logged in", %{conn: conn} do
      log = insert(:log)
      conn = delete(conn, Routes.log_path(conn, :delete, log))

      assert redirected_to(conn) ==
               Routes.pow_session_path(conn, :new, request_path: "/logs/#{log.id}")
    end

    test "deletes chosen log when user is logged in", %{conn: conn} do
      user = insert(:user)
      log = insert(:log, user: user)

      conn =
        conn
        |> log_in(user)
        |> delete(Routes.log_path(conn, :delete, log))

      assert redirected_to(conn) == Routes.log_path(conn, :index)
    end

    test "Cannot delete log when different user", %{conn: conn} do
      user = insert(:user)
      user2 = insert(:user, email: "other@email.com")
      log = insert(:log, user: user)

      conn =
        conn
        |> log_in(user2)
        |> delete(Routes.log_path(conn, :delete, log))

      assert response(conn, 403) =~ "Forbidden"
    end
  end
end
