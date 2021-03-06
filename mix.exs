defmodule Buzzword.Bingo.LiveView.Client.MixProject do
  use Mix.Project

  def project do
    [
      app: :buzzword_bingo_liveview_client,
      version: "0.1.20",
      elixir: "~> 1.12",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Buzzword.Bingo.LiveView.Client.Application, []},
      extra_applications: [:logger, :runtime_tools]
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
      {:phoenix, "~> 1.6.6"},
      {:phoenix_html, "~> 3.0"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 0.17.5"},
      {:floki, ">= 0.30.0", only: :test},
      {:phoenix_live_dashboard, "~> 0.6"},
      {:esbuild, "~> 0.3", runtime: Mix.env() == :dev},
      {:telemetry_metrics, "~> 0.6"},
      {:telemetry_poller, "~> 1.0"},
      {:gettext, "~> 0.18"},
      {:jason, "~> 1.2"},
      {:plug_cowboy, "~> 2.5"},
      # Added dependencies...
      {:buzzword_bingo_engine, github: "RaymondLoranger/buzzword_bingo_engine"},
      {:phoenix_ecto, "~> 4.4"},
      {:tailwind, "~> 0.1", runtime: Mix.env() == :dev},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      # {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:logger_file_backend, "~> 0.0.11"},
      {:log_reset, "~> 0.1"},
      {:persist_config, "~> 0.4", runtime: false},
      {:phx_formatter, "~> 0.1", only: :dev, runtime: false},
      {:clipboard, "~> 0.2"},
      {:heroicons, "~> 0.3.2"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks,
  # run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get"],
      # "assets.deploy": ["esbuild default --minify", "phx.digest"]
      "assets.deploy": [
        "tailwind default --minify",
        "esbuild default --minify",
        "phx.digest"
      ]
    ]
  end
end
