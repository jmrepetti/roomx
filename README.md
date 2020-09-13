# Roomx

To start your Phoenix server:

  * Setup the project with `mix setup`

DB setup:

  * If using docker you can start a postgres container with `./postgres_docker.sh`
  * Create database with `mix ecto.create`

Start server:

  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000/rooms`](http://localhost:4000/rooms) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## TODO

- [] save board state
- [x] add layer/overlay for showing/hiding cells
  - [x] handle clicks