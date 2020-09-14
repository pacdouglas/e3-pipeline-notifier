defmodule E3PipelineNotifier.MixProject do
  use Mix.Project

  def project do
    [
      app: :e3_pipeline_notifier,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      escript: escript()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger, :sqlite_ecto2, :ecto, :bamboo, :bamboo_smtp],
      mod: {E3PipelineNotifier.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.6"},
      {:poison, "~> 3.1"},
      {:sqlite_ecto2, "~> 2.2"},
      {:bamboo_smtp, "~> 3.0.0"}
    ]
  end

  defp escript do
    [main_module: E3PipelineNotifier.CLI]
  end
end
