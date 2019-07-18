defmodule HealthWeb.LayoutViewTest do
  use HealthWeb.ConnCase, async: true

  alias HealthWeb.LayoutView
  import Phoenix.HTML, only: [safe_to_string: 1]

  test "when inactive (request path does not match to)" do
    html =
      HealthWeb.LayoutView.nav_link(%{request_path: "/test"}, "Test", to: "/")
      |> safe_to_string()

    assert html == "<li class=\"nav-item\"><a class=\"nav-link\" href=\"/\">Test</a></li>"
  end

  test "when active (request path matches to)" do
    html =
      HealthWeb.LayoutView.nav_link(%{request_path: "/"}, "Test", to: "/")
      |> safe_to_string()

    assert html == "<li class=\"nav-item active\"><a class=\"nav-link\" href=\"/\">Test</a></li>"
  end

  test "additional options are included on the link tag" do
    html =
      HealthWeb.LayoutView.nav_link(%{request_path: "/"}, "Test", to: "/", class: "test", target: "_blank")
      |> safe_to_string()

    assert html == "<li class=\"nav-item active\"><a class=\"nav-link test\" href=\"/\" target=\"_blank\">Test</a></li>"
  end
end
