defmodule HealthWeb.ContactControllerTest do
  @moduledoc false
  use HealthWeb.ConnCase, async: true

  @good_params %{
    name: Faker.StarWars.character(),
    from_email: Faker.Internet.email(),
    message: Faker.Lorem.sentence(10..50)
  }

  @bad_params %{
    name: Faker.StarWars.character(),
    from_email: nil,
    message: Faker.Lorem.sentence(10..50)
  }

  describe "new contact form" do
    test "renders form", %{conn: conn} do
      conn =
        conn
        |> get(Routes.contact_path(conn, :new))

      assert html_response(conn, 200) =~ "Contact"
    end
  end

  describe "create contact message" do
    test "redirects to main page when data is valid", %{conn: conn} do
      conn2 =
        conn
        |> post(Routes.contact_path(conn, :create), message: @good_params)

      assert redirected_to(conn2) == Routes.page_path(conn2, :index)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        conn
        |> post(Routes.contact_path(conn, :create),
          message: @bad_params
        )

      assert html_response(conn, 200)
    end
  end
end
