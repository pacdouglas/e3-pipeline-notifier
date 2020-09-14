use Mix.Config

config :e3_pipeline_notifier, E3PipelineNotifier.Repo,
  adapter: Sqlite.Ecto2,
  database: System.get_env("NOTIFIED_PIPELINE_SQLITE_DB")

  config :e3_pipeline_notifier, ecto_repos: [E3PipelineNotifier.Repo]

config :e3_pipeline_notifier, E3PipelineNotifier.Mailer,
adapter: Bamboo.SMTPAdapter,
server: {:system, "SMTP_SERVER"}, # set the env variable
hostname: {:system, "SMTP_HOSTNAME"}, # set the env variable
port: {:system, "SMTP_PORT"} #set the env variable
username: {:system, "SMTP_USERNAME"}, # set the env variable
password: {:system, "SMTP_PASSWORD"}, # set the env variable
tls: :always, # can be `:always` or `:never`
ssl: false, # can be `true`
retries: 3
