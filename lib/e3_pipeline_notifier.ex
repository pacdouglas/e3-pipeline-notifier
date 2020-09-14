defmodule E3PipelineNotifier.Mailer do
  use Bamboo.Mailer, otp_app: :e3_pipeline_notifier
end

defmodule E3PipelineNotifier do
  import Bamboo.Email
  import Ecto.Query
  use Mix.Task
  alias E3PipelineNotifier.Repo, as: DB

  def run(configFilePath) do
    {:ok, json} = configFilePath |> File.read
    {:ok, envs} = Poison.decode(json, as: [%E3PipelineNotifier.Environment{}])

    Enum.each(envs,
      fn env ->
        {:ok, failedPipelines} = requestFailedPipelines(env.url)

        failedPipelinesNotNotifiedYet = Enum.filter(failedPipelines,
          fn pipeline ->
            alreadyNotified(pipeline, env) == false
          end
        )
        sendEmails(env, failedPipelinesNotNotifiedYet)
        saveNotifiedPipeline(env, failedPipelinesNotNotifiedYet)
      end
    )
  end

  def alreadyNotified(pipelineFromServer, env) do
    DB.one(
      E3PipelineNotifier.Pipeline
      |> select([pipeline], pipeline)
      |> where([pipeline], pipeline.environment == ^env.name and pipeline.pipelineId == ^pipelineFromServer.id)
    ) != nil
  end

  def requestFailedPipelines(url) do
    pipelineUrl = url <> "/creation-date-ordered?limit=20&status=FAILED"

    case HTTPoison.get(pipelineUrl, [], hackney: [:insecure]) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, Poison.decode!(body, as: [%E3PipelineNotifier.Pipeline{}])}
      _ ->
        {:error, nil}
    end
  end

  def sendEmails(env, pipelines) do
    Enum.each(
      pipelines,
      fn pipeline ->
        new_email(
          to: env.emails,
          subject: "Pipeline com falha no ambiente #{env.name}",
          html_body: "<strong>Pipeline com falha - id: #{pipeline.id} #{pipeline.name}</strong>"
        )
        |> E3PipelineNotifier.Mailer.deliver_now
      end
    )
  end

  def saveNotifiedPipeline(env, pipelines) do
    Enum.each(
      pipelines,
      fn pipeline ->
        %E3PipelineNotifier.Pipeline {
          name: pipeline.name,
          type: pipeline.type,
          environment: env.name,
          pipelineId: pipeline.id
        }
        |> DB.insert()
      end
    )
  end
end
