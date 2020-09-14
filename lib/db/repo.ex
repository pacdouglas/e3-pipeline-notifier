defmodule E3PipelineNotifier.Repo do
    use Ecto.Repo, otp_app: :e3_pipeline_notifier, adapter: Sqlite.Ecto2
end
