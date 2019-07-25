defmodule HealthWeb.BootstrapHelperTest do
  @moduledoc false
  use HealthWeb.ConnCase, async: true

  use Phoenix.HTML
  import HealthWeb.BootstrapHelper

  test "nav_link when inactive (request path does not match to)" do
    html =
      nav_link(%{request_path: "/test"}, "Test", to: "/")
      |> safe_to_string()

    assert html == "<li class=\"nav-item\"><a class=\"nav-link\" href=\"/\">Test</a></li>"
  end

  test "nav_link when active (request path matches to)" do
    html =
      nav_link(%{request_path: "/"}, "Test", to: "/")
      |> safe_to_string()

    assert html == "<li class=\"nav-item active\"><a class=\"nav-link\" href=\"/\">Test</a></li>"
  end

  test "nav_link additional options are included on the link tag" do
    html =
      nav_link(%{request_path: "/"}, "Test",
        to: "/",
        class: "test",
        target: "_blank"
      )
      |> safe_to_string()

    assert html ==
      "<li class=\"nav-item active\"><a class=\"nav-link test\" href=\"/\" target=\"_blank\">Test</a></li>"
  end

  test "tabs renders correctly" do
    html = tabs do
      content_tag(:p, "No content")
    end |> safe_to_string()

    assert html == "<ul class=\"nav nav-tabs\" role=\"tablist\"></ul><div class=\"tab-content\"></div>"
  end

end
