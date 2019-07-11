defmodule HealthWeb.PageControllerTest do
  use HealthWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Health"
  end
end
