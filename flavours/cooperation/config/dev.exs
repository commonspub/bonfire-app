import Config

config :bonfire, Bonfire.Common.Repo,
  experimental_features_enabled: true, # Note: you can run `Bonfire.Common.Config.put(:experimental_features_enabled, true)` to enable these in prod too
  database: System.get_env("POSTGRES_DB", "bonfire_dev"),
  # show_sensitive_data_on_connection_error: true,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  log: false # EctoSparkles does the logging instead

path_dep_dirs =
  Mess.deps([path: "deps.path"], [])
  |> Enum.map(&(Keyword.fetch!(elem(&1, 1), :path) <> "/lib"))

config :phoenix_live_reload,
  dirs: path_dep_dirs ++ ["lib/"] # watch the app's lib/ dir + the dep/lib/ dir of every locally-cloned dep

path_dep_patterns = path_dep_dirs |> Enum.map(&(String.slice(&1, 2..1000) <>".*ex")) # to include cloned code in patterns
path_dep_patterns = path_dep_patterns ++ path_dep_dirs |> Enum.map(&(String.slice(&1, 2..1000) <>".*sface")) # Surface views

# Watch static and templates for browser reloading.
config :bonfire, Bonfire.Web.Endpoint,
  server: true,
  debug_errors: true,
  check_origin: false,
  code_reloader: true,
  watchers: [
    yarn: [
      "watch.js",
      cd: Path.expand("assets", File.cwd!())
    ],
    yarn: [
      "watch.css",
      cd: Path.expand("assets", File.cwd!())
    ],
    yarn: [
      "watch.assets",
      cd: Path.expand("assets", File.cwd!())
    ]
  ],
  live_reload: [
    patterns: [
      # ~r"^priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      # ~r"^priv/gettext/.*(po)$",
      # ~r"^web/(live|views)/.*ex$",
      # ~r"^lib/.*_live\.ex$",
      # ~r".*leex$",
      ~r"lib/.*ex$",
      ~r".*sface$",
      ~r"priv/catalogue/.*(ex)$",
    ] ++ path_dep_patterns
  ]

# defp elixirc_paths(:dev), do: ["lib"] ++ catalogues()

config :logger, :console,
  level: :debug,
  # truncate: :infinity,
  format: "[$level] $message\n" # Do not include metadata or timestamps

config :phoenix, :stacktrace_depth, 30

config :phoenix, :plug_init_mode, :runtime

config :exsync,
  src_monitor: true,
  extra_extensions: [".leex", ".heex", ".js", ".css", ".sface"]
