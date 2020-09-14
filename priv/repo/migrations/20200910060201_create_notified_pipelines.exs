defmodule E3PipelineNotifier.Repo.Migrations.CreateNotifiedPipelines do
  use Ecto.Migration

  def change do
    create table(:pipelines) do
      add(:name, :string)
      add(:type, :string)
      add(:environment, :string)
      add(:pipelineId, :integer)
      timestamps()
    end
    create index(:pipelines, [:environment, :pipelineId])
  end
end
