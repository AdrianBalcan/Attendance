use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.

# You can generate a new secret by running:
#
#     mix phoenix.gen.secret
config :attendance, Attendance.Repo,
  secret_key_base: "U3QXzG0XBZKF2Yn7USbyUZJwOJOfW8aHTtusG8MShvak/BhmKlZ1CdYBqSTK8Oqw"

# Configure your database
config :attendance, Attendance.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "attendance",
  password: "attzog",
  database: "attendance_dev",
  hostname: "db",
  pool_size: 10
