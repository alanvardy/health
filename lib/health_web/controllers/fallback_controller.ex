defmodule HealthWeb.FallbackController do
  use HealthWeb, :controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:forbidden)
    |> render(HealthWeb.ErrorView, :"403")
  end
end