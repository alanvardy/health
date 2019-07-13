# credo:disable-for-this-file
defmodule HealthWeb.FallbackController do
  use HealthWeb, :controller

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(:forbidden)
    |> put_view(HealthWeb.ErrorView)
    |> render(:"403")
  end
end
