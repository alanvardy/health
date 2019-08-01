defmodule HealthWeb.PageController do
  use HealthWeb, :controller

  @spec index(%Plug.Conn{}, map) :: %Plug.Conn{}
  def index(conn, _params) do
    conn
    |> render("index.html")
  end

end
