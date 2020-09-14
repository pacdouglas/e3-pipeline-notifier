defmodule E3PipelineNotifier.Pipeline do
  use Ecto.Schema

  schema "pipelines" do
    field(:name, :string)
    field(:type, :string)
    field(:environment, :string)
    field(:pipelineId, :integer)
    timestamps()
  end
end

defmodule E3PipelineNotifier.Environment do
  defstruct name: "", url: "", emails: [ "" ]
end