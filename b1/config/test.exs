import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :b1, B1Web.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "QJi0N+wDzkXlvd7bLYpMzK7/Z5X4FkukY9REPrGV8bHXvE+utwlLBPhUoK58D4Cz",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
