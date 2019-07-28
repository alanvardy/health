defmodule Health.MixProject do
  @moduledoc false

  use Mix.Project

  def project do
    [
      app: :health,
      version: "0.1.0",
      elixir: "~> 1.8",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test
      ],
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      # Extra apps for dialyxer
      deps: deps(),

      # Docs
      name: "Health",
      source_url: "https://github.com/alanvardy/health",
      homepage_url: "https://health.vardy.codes/",
      docs: [
        # The main page in the docs
        main: "Health",
        logo: "assets/static/images/logo.png",
        extras: ["README.md"]
      ]
    ]
  end

  # Configuration for ther OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Health.Application, []},
      extra_applications: [:timex, :logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.4.7"},
      {:phoenix_pubsub, "~> 1.1"},
      {:phoenix_ecto, "~> 4.0"},
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.11"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:better_params, "~> 0.5.0"},
      {:timex, "~> 3.0"},
      {:csv, "~> 2.3"},
      # Auth
      {:pow, "~> 1.0.11"},
      {:bodyguard, "~> 2.2"},
      # Testing
      {:ex_machina, "~> 2.3", only: :test},
      {:faker, "~> 0.12", only: :test},
      {:excoveralls, "~> 0.10", only: :test, runtime: false},
      # Tooling
      {:credo, "~> 1.1.0", only: [:dev, :test], runtime: false},
      {:sshex, "~> 2.2.1"},
      {:ex_doc, "~> 0.21", only: :dev, runtime: false},
      {:sobelow, "~> 0.8", only: :dev},
      {:ex_check, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:dialyxir, ">= 0.0.0", only: :dev, runtime: false}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
