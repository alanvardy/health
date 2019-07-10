defmodule HealthWeb.PageController do
  use HealthWeb, :controller

  def index(conn, _params) do
    conn
    |> render("index.html")
  end
end
