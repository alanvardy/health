defmodule HealthWeb.Router do
  use HealthWeb, :router
  use Pow.Phoenix.Router

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  @csp "style-src 'self' 'unsafe-inline' 'unsafe-eval'"

  pipeline :browser do
    plug :accepts, ["html"]
    plug :put_secure_browser_headers, %{"content-security-policy" => @csp}
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
    resources "/contact", HealthWeb.ContactController, only: [:new, :create]
    pow_routes()

    # View sent emails at http://localhost:4000/sent_emails
    if Mix.env() == :dev do
      # If using Phoenix
      forward "/sent_emails", Bamboo.SentEmailViewerPlug
    end
  end

  # Protected routes
  scope "/", HealthWeb do
    pipe_through [:browser, :protected]
    resources "/users", UserController, only: [:index, :edit, :update]
    # must be before resources "/measurements"
    get "/measurements/export", MeasurementController, :export
    resources "/measurements", MeasurementController
    resources "/weights", WeightController, except: [:new, :show]
    get "/weights/export", WeightController, :export
  end

  # Other scopes may use custom stacks.
  # scope "/api", HealthWeb do
  #   pipe_through :api
  # end
end
