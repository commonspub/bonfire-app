Code.eval_file("lib/mix/mess/mess.exs")
Code.eval_file("lib/mix/mess/mixer.ex")

defmodule Bonfire.MixProject do
  use Mix.Project
  alias Bonfire.Mixer

  @extra_deps [
    ## password hashing - builtin vs nif
    {:pbkdf2_elixir, "~> 2.0", only: [:dev, :test]},
    {:argon2_elixir, "~> 3.0", only: [:prod]},

    # error reporting
    {:sentry, "~> 8.0", only: [:dev, :prod]},

    ## dev conveniences
    # {:dbg, "~> 1.0", only: [:dev, :test]},
    {:phoenix_live_reload, "~> 1.3", only: :dev},
    # {:exsync, git: "https://github.com/falood/exsync", only: :dev},
    # {:mix_unused, "~> 0.4", only: :dev},
    {:ex_doc, "~> 0.28.3", only: [:dev, :test], runtime: false},
    {:ecto_erd, "~> 0.4", only: :dev},
    # {:ecto_dev_logger, "~> 0.4", only: :dev},
    # flame graphs in live_dashboard
    # {:flame_on, "~> 0.5", only: :dev},
    {:pseudo_gettext, git: "https://github.com/tmbb/pseudo_gettext", only: :dev},
    {:periscope, "~> 0.4", only: :dev},
    # {:changelog, "~> 0.1", only: [:dev, :test], runtime: false}, # retrieve changelogs of latest dependency versions
    # changelog generation
    {:versioce, "~> 1.1.2", only: :dev},
    # needed for changelog generation
    {:git_cli, "~> 0.3.0", only: :dev},
    # {:archeometer, git: "https://gitlab.com/mayel/archeometer", only: [:dev, :test]}, # "~> 0.1.0" # disabled because exqlite not working in CI
    {:recode, "~> 0.4", only: :dev},
    # API client needed for changelog generation
    {:neuron, "~> 5.0", only: :dev, override: true},
    # note: cannot use only: dev
    # {:phoenix_profiler, "~> 0.2.0"},

    # tests
    {:floki, ">= 0.0.0", only: [:dev, :test]},
    {:ex_machina, "~> 2.4", only: :test},
    {:mock, "~> 0.3", only: :test},
    {:mox, "~> 1.0", only: :test},
    {:zest, "~> 0.1.0"},
    {:grumble, "~> 0.1.3", only: [:test], override: true},
    {:mix_test_watch, "~> 1.1", only: :test, runtime: false, override: true},
    {:mix_test_interactive, "~> 1.2", only: :test, runtime: false},
    {:ex_unit_notifier, "~> 1.0", only: :test},
    {:wallaby, "~> 0.30", runtime: false, only: :test},
    # {:bypass, "~> 2.1", only: :test}, # used in furlex

    # Benchmarking utilities
    {:benchee, "~> 1.1", only: :dev},
    {:benchee_html, "~> 1.0", only: :dev},

    # list dependencies & licenses
    {
      :licensir,
      only: :dev,
      runtime: false,
      git: "https://github.com/bonfire-networks/licensir",
      branch: "main"
      # path: "./forks/licensir"
    },

    # security auditing
    # {:mix_audit, "~> 0.1", only: [:dev], runtime: false}
    {:sobelow, "~> 0.8", only: :dev}
  ]

  # TODO: put these in ENV or an external writeable config file similar to deps.*
  @default_flavour "classic"
  @config [
    # note that the flavour will automatically be added where the dash appears
    version: "0.3.6-beta.1",
    elixir: "~> 1.13",
    default_flavour: @default_flavour,
    logo: "assets/static/images/bonfire-icon.png",
    guides: [
      "README.md",
      "docs/HACKING.md",
      "docs/DEPLOY.md",
      "docs/ARCHITECTURE.md",
      "docs/BONFIRE-FLAVOURED-ELIXIR.md",
      "docs/DATABASE.md",
      "docs/BOUNDARIES.md",
      "docs/GRAPHQL.md",
      "docs/MRF.md",
      "docs/CHANGELOG.md",
      "docs/CHANGELOG-autogenerated.md"
    ],
    deps_prefixes: [
      docs: [
        "bonfire",
        "pointers",
        "paginator",
        "ecto_shorts",
        "ecto_sparkles",
        "absinthe_client",
        "activity_pub",
        "arrows",
        "ecto_materialized_path",
        "flexto",
        "grumble",
        "linkify",
        "verbs",
        "voodoo",
        "waffle",
        "zest"
      ],
      test: [
        "bonfire",
        "pointers",
        "paginator",
        "ecto_shorts",
        "ecto_sparkles",
        "activity_pub",
        "arrows",
        "linkify",
        "fetch_favicon"
      ],
      data: [
        "bonfire_data_",
        "bonfire_data_edges",
        "pointers",
        "bonfire_boundaries",
        "bonfire_tag",
        "bonfire_classify",
        "bonfire_geolocate",
        "bonfire_quantify",
        "bonfire_valueflows"
      ],
      api: [
        "bonfire_me",
        "bonfire_social",
        "bonfire_tag",
        "bonfire_classify",
        "bonfire_geolocate",
        "bonfire_valueflows"
      ],
      required: [
        "bonfire_boundaries",
        "bonfire_social",
        "bonfire_me",
        "bonfire_ecto",
        "bonfire_epics",
        "bonfire_common"
      ],
      localise: ["bonfire"],
      localise_self: []
    ],
    deps: Mess.deps(Mixer.mess_sources(@default_flavour), @extra_deps)
  ]

  def config, do: @config
  def deps, do: config()[:deps]

  def project do
    [
      app: :bonfire,
      version: Mixer.version(config()),
      elixir: config()[:elixir],
      elixirc_options: [debug_info: true, docs: true],
      elixirc_paths: Mixer.elixirc_paths(config(), Mix.env()),
      test_paths: Mixer.test_paths(config()),
      test_deps: Mixer.deps(config(), :test),
      required_deps: config()[:deps_prefixes][:required],
      compilers: Mixer.compilers(Mix.env()),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      multirepo_deps: Mixer.deps(config(), :bonfire),
      in_multirepo_fn: &Mixer.in_multirepo?/1,
      multirepo_recompile_fn: &Mixer.deps_recompile/0,
      config_path: Mixer.config_path(config(), "config.exs"),
      releases: [
        bonfire: [
          runtime_config_path: Mixer.config_path(config(), "runtime.exs"),
          # to enable debugging
          strip_beams: false
        ]
      ],
      sources_url: "https://github.com/bonfire-networks",
      source_url: "https://github.com/bonfire-networks/bonfire-app",
      homepage_url: "https://bonfirenetworks.org",
      docs: [
        # The first page to display from the docs
        main: "readme",
        logo: config()[:logo],
        output: "docs/exdoc",
        source_url_pattern: &Mixer.source_url_pattern/2,
        # extra pages to include
        extras: Mixer.readme_paths(config()),
        # extra apps to include in module docs
        source_beam: Mixer.beam_paths(config(), :docs),
        deps: Mixer.doc_deps(config()),
        # Note: first match wins
        groups_for_extras: [
          Guides: Path.wildcard("docs/*"),
          "Flavours of Bonfire": Path.wildcard("flavours/*/*"),
          "Data schemas": Path.wildcard("{deps,forks}/bonfire_data_*/*"),
          "UI extensions": Path.wildcard("{deps,forks}/bonfire_ui_*/*"),
          "Bonfire utilities":
            [
              "bonfire_api_graphql",
              "bonfire_boundaries",
              "bonfire_common",
              "bonfire_ecto",
              "bonfire_epics",
              "bonfire_fail",
              "bonfire_files",
              "bonfire_mailer"
            ]
            |> Enum.flat_map(&Path.wildcard("{deps,forks}/#{&1}/*")),
          "Feature extensions": Path.wildcard("{deps,forks}/bonfire_*/*"),
          "Other utilities": Path.wildcard("{deps,forks}/*/*"),
          Dependencies: Path.wildcard("docs/DEPENDENCIES/*")
        ],
        groups_for_modules: [
          "Data schemas": ~r/^Bonfire.Data.?/,
          "UI extensions": ~r/^Bonfire.UI.?/,
          "Bonfire utilities": [
            ~r/^Bonfire.API?/,
            ~r/^Bonfire.GraphQL?/,
            ~r/^Bonfire.Web?/,
            ~r/^Bonfire.Boundaries?/,
            ~r/^Bonfire.Common?/,
            ~r/^Bonfire.Ecto?/,
            ~r/^Bonfire.Epics?/,
            ~r/^Bonfire.Fail?/,
            ~r/^Bonfire.Files?/,
            ~r/^Bonfire.Mailer?/
          ],
          "Feature extensions": [~r/^Bonfire.?/, ~r/^ValueFlows.?/],
          Utilities: ~r/.?/
        ],
        nest_modules_by_prefix: [
          Bonfire.Data,
          # Bonfire.UI,
          Bonfire,
          ValueFlows
        ]
      ]
    ]
  end

  def application do
    [
      mod: {Bonfire.Application, []},
      extra_applications: [
        :logger,
        :runtime_tools,
        :os_mon,
        :ssl,
        :bamboo,
        :bamboo_smtp
      ]
    ]
  end

  defp aliases do
    [
      "hex.setup": ["local.hex --force"],
      "rebar.setup": ["local.rebar --force"],
      "assets.build": [
        "cmd cd ./assets && yarn build"
      ],
      "bonfire.seeds": [
        # "phil_columns.seed",
      ],
      "bonfire.deps.update": ["deps.update " <> Mixer.deps_to_update(config())],
      "bonfire.deps.clean": [
        "deps.clean " <> Mixer.deps_to_clean(config(), :localise) <> " --build"
      ],
      "bonfire.deps.clean.data": [
        "deps.clean " <> Mixer.deps_to_clean(config(), :data) <> " --build"
      ],
      "bonfire.deps.clean.api": [
        "deps.clean " <> Mixer.deps_to_clean(config(), :api) <> " --build"
      ],
      "bonfire.deps.recompile": [
        "deps.compile " <> Mixer.deps_to_update(config()) <> " --force"
      ],
      "ecto.seeds": [
        "run #{Mixer.flavour_path(config())}/repo/seeds.exs"
      ],
      "js.deps.get": ["cmd make js.deps.get"],
      "js.deps.update": ["cmd cd assets && yarn update"],
      setup: [
        "hex.setup",
        "rebar.setup",
        "deps.get",
        "bonfire.deps.clean.data",
        "ecto.setup"
      ],
      updates: ["deps.get", "bonfire.deps.update"],
      upgrade: ["updates", "ecto.migrate"],
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.migrate": ["ecto.migrate", "bonfire.seeds"],
      "ecto.reset": ["ecto.drop --force", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
