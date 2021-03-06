defmodule HealthWeb.UserControllerTest do
  @moduledoc false
  alias Health.Account
  use HealthWeb.ConnCase, async: true

  describe "index users" do
    test "doesn't render index when not logged in", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))

      assert redirected_to(conn) ==
               Routes.pow_session_path(conn, :new, request_path: "/users")
    end

    test "doesn't show index for member", %{conn: conn} do
      conn =
        conn
        |> insert_and_log_in(:user)
        |> get(Routes.user_path(conn, :index))

      assert response(conn, 403) =~ "Forbidden"
    end

    test "renders index when admin", %{conn: conn} do
      conn =
        conn
        |> insert_and_log_in(:admin)
        |> get(Routes.user_path(conn, :index))

      assert html_response(conn, 200) =~ "Users"
    end
  end

  describe "edit user" do
    test "doesn't render form when not logged in", %{conn: conn} do
      user = insert(:user)
      conn = get(conn, Routes.user_path(conn, :edit, user))

      assert redirected_to(conn) ==
               Routes.pow_session_path(conn, :new, request_path: "/users/#{user.id}/edit")
    end

    test "doesn't show form for editing user member logged in", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> log_in(user)
        |> get(Routes.user_path(conn, :edit, user))

      assert response(conn, 403) =~ "Forbidden"
    end

    test "renders form for editing chosen user when admin", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> insert_and_log_in(:admin)
        |> get(Routes.user_path(conn, :edit, user))

      assert html_response(conn, 200) =~ "User Settings"
    end
  end

  describe "update user" do
    test "redirects to login when not logged in", %{conn: conn} do
      user = insert(:user)
      conn = put(conn, Routes.user_path(conn, :update, user), user: params_for(:user, roles: 2))

      assert redirected_to(conn) ==
               Routes.pow_session_path(conn, :new)
    end

    test "redirects when data is valid and admin is logged in", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> insert_and_log_in(:admin)
        |> put(Routes.user_path(conn, :update, user), user: params_for(:user, roles: 2))

      assert redirected_to(conn) == Routes.user_path(conn, :edit, user)
      user = Account.get_editable_user(user.id)
      assert user.roles == 2
    end

    test "rejects when data is valid and a regular user is logged in", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> log_in(user)
        |> put(Routes.user_path(conn, :update, user), user: params_for(:user, roles: 2))

      assert response(conn, 403) =~ "Forbidden"
    end

    test "renders errors when data is invalid and admin is logged in", %{conn: conn} do
      user = insert(:user)

      conn =
        conn
        |> insert_and_log_in(:admin)
        |> put(Routes.user_path(conn, :update, user), user: params_for(:user, roles: ""))

      assert html_response(conn, 200) =~ "User Settings"
    end
  end
end
