import Config


config :aloi, Aloi.TestCaseConfig.Api, implementation: Aloi.TestCaseConfig.Implementation, no_implementation: false
config :aloi, Aloi.TestCaseExternalBehaviour.Api, implementation: Aloi.TestCaseExternalBehaviour.Implementation, no_implementation: false
config :aloi, Aloi.TestCaseNoImpl, no_implementation: true
