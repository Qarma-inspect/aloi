import Config

config :aloi, Aloi.TestCaseExternalBehaviour.Api, no_implementation: true
config :aloi, Aloi.TestCaseConfig.Api, no_implementation: true
config :aloi, Aloi.TestCaseNoImpl, no_implementation: true

import_config "#{Mix.env()}.exs"
