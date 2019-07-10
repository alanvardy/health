defmodule HealthWeb.PageController do
  use HealthWeb, :controller

  def index(conn, _params) do
    conn
    |> put_flash(:danger, "oh no my friend")
    |> put_flash(:success, "woot my friend")
    |> render("index.html")

  end

  def protected(conn, _params) do
    conn
    |> put_flash(:danger, "oh no my friend")
    |> put_flash(:success, "woot my friend")
    |> render("protected.html")

  end
end
