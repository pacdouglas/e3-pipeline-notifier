defmodule E3PipelineNotifier.Application do
  use Application

  def start(_type, _args) do
    children = [
      E3PipelineNotifier.Repo
    ]

    opts = [strategy: :one_for_one, name: E3PipelineNotifier.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule E3PipelineNotifier.CLI do
  def main(_args) do
    children = [
      E3PipelineNotifier.Repo
    ]

    opts = [strategy: :one_for_one, name: E3PipelineNotifier.Supervisor]
    Supervisor.start_link(children, opts)

    _args
    |> Enum.at(0)
    |> E3PipelineNotifier.run
  end
end
