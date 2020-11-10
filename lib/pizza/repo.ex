defmodule Pizza.Repo do
  use Ecto.Repo,
    otp_app: :pizza,
    adapter: Ecto.Adapters.Postgres
end
