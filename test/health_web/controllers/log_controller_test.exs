defmodule HealthWeb.LogControllerTest do
  use HealthWeb.ConnCase

  alias Health.Stats
  # alias Pow.Ecto.Context, as: Pow

  @create_attrs %{date: "2010-04-17T14:00:00Z", weight: 42, user_id: 1}
  @update_attrs %{date: "2011-05-18T15:01:01Z", weight: 43, user_id: 1}
  @invalid_attrs %{date: nil, weight: nil, user_id: nil}

  def fixture(:log) do
    {:ok, log} = Stats.create_log(@create_attrs)
    log
  end

  def fixture(:user) do

    {:ok, user} = Pow.pow_create(%{email: "test@test.com", password: "password", password_confirmation: "password"})
    user
  end

  describe "index" do
    # test "doesn't list logs when not logged in", %{conn: conn} do
    #   conn = get(conn, Routes.log_path(conn, :index))
    #   assert redirected_to(conn) == Routes.pow_session_path(conn, :new, request_path: "/log")
    # end
    # test "lists all log", %{conn: conn} do
    #   conn = get(conn, Routes.log_path(conn, :index))
    #   assert html_response(conn, 200) =~ "Listing Log"
    # end
  end

  describe "new log" do
    # test "doesn't render form when not logged in", %{conn: conn} do
    #   conn = get(conn, Routes.log_path(conn, :new))
    #   assert redirected_to(conn) == Routes.pow_session_path(conn, :new, request_path: "/log/new")
    # end
    # test "renders form", %{conn: conn} do
    #   conn = get(conn, Routes.log_path(conn, :new))
    #   assert html_response(conn, 200) =~ "New Log"
    # end
  end

  describe "create log" do
    # test "doesn't create when not logged in", %{conn: conn} do
    #   conn = post(conn, Routes.log_path(conn, :create), log: @create_attrs)

    #   assert redirected_to(conn) == Routes.pow_session_path(conn, :new, request_path: "/log")
    # end
    # test "redirects to show when data is valid", %{conn: conn} do
    #   conn = post(conn, Routes.log_path(conn, :create), log: @create_attrs)

    #   assert %{id: id} = redirected_params(conn)
    #   assert redirected_to(conn) == Routes.log_path(conn, :show, id)

    #   conn = get(conn, Routes.log_path(conn, :show, id))
    #   assert html_response(conn, 200) =~ "Show Log"
    # end

    # test "renders errors when data is invalid", %{conn: conn} do
    #   conn = post(conn, Routes.log_path(conn, :create), log: @invalid_attrs)
    #   assert html_response(conn, 200) =~ "New Log"
    # end
  end

  describe "edit log" do
    # setup [:create_user, :create_log]

    # test "doesn't render form when not logged in", %{conn: conn, log: log} do
    #   conn = get(conn, Routes.log_path(conn, :edit, log))
    #   assert redirected_to(conn) == Routes.pow_session_path(conn, :new, request_path: "/log")
    # end

    # test "renders form for editing chosen log", %{conn: conn, log: log} do
    #   conn = get(conn, Routes.log_path(conn, :edit, log))
    #   assert html_response(conn, 200) =~ "Edit Log"
    # end
  end

  describe "update log" do
    # setup [:create_user, :create_log]

    # test "redirects to log in when not logged in", %{conn: conn, log: log} do
    #   conn = put(conn, Routes.log_path(conn, :update, log), log: @update_attrs)
    #   assert redirected_to(conn) == Routes.pow_session_path(conn, :new, request_path: "/log")
    # end

    # test "redirects when data is valid", %{conn: conn, log: log} do
    #   conn = put(conn, Routes.log_path(conn, :update, log), log: @update_attrs)
    #   assert redirected_to(conn) == Routes.log_path(conn, :show, log)

    #   conn = get(conn, Routes.log_path(conn, :show, log))
    #   assert html_response(conn, 200)
    # end

    # test "renders errors when data is invalid", %{conn: conn, log: log} do
    #   conn = put(conn, Routes.log_path(conn, :update, log), log: @invalid_attrs)
    #   assert html_response(conn, 200) =~ "Edit Log"
    # end
  end

  describe "delete log" do
# setup [:create_user, :create_log]

#     test "redirects to log in when not logged in", %{conn: conn, log: log} do
#       conn = delete(conn, Routes.log_path(conn, :delete, log))
#       assert redirected_to(conn) == Routes.pow_session_path(conn, :new, request_path: "/log")
#     end

    # test "deletes chosen log", %{conn: conn, log: log} do
    #   conn = delete(conn, Routes.log_path(conn, :delete, log))
    #   assert redirected_to(conn) == Routes.log_path(conn, :index)
    #   assert_error_sent 404, fn ->
    #     get(conn, Routes.log_path(conn, :show, log))
    #   end
    # end
  end

  defp create_log(_) do
    log = fixture(:log)
    {:ok, log: log}
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
