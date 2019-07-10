defmodule HealthWeb.Router do
  use HealthWeb, :router
  use Pow.Phoenix.Router

  alias HealthWeb.Plugs

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
      plug Plugs.CurrentUser
    end

    pipeline :browser do
      plug :accepts, ["html"]
      plug :fetch_session
      plug :fetch_flash
      plug :protect_from_forgery
      plug :put_secure_browser_headers
  end

  # pipeline :api do
  #   plug :accepts, ["json"]
  # end

  # Unprotected routes
  scope "/" do
    pipe_through :browser

    get "/", HealthWeb.PageController, :index
    pow_routes()
  end

  # Protected routes
  scope "/", HealthWeb do
    pipe_through [:browser, :protected]
    resources "/logs", LogController
  end

  # Other scopes may use custom stacks.
  # scope "/api", HealthWeb do
  #   pipe_through :api
  # end
end
