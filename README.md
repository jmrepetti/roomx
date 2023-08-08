# Roomx

To start your Phoenix server:

    podman-compose run phoenix mix deps.get
    podman-compose run phoenix mix deps.compile
    podman-compose run phoenix mix ecto.create
    podman-compose run phoenix mix ecto.migrate
    podman-compose run phoenix npm install --prefix ./assets
    podman-compose up    


Now you can visit [`localhost:4000/rooms`](http://localhost:4000/rooms) from your browser.

