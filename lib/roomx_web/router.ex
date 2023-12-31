defmodule RoomxWeb.Router do
  use RoomxWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {RoomxWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", RoomxWeb do
    pipe_through :browser

    # get "/", PageController, :index
    resources "/rooms", RoomController

    # live "/r/mines/:game_id", MinesRoomLive
    live "/mines/:room_id", RoomMinesLive
    live "/tateti/:room_id", RoomTatetiLive

    # live "/r/words/:session_id", WordsRoomLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", RoomxWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: RoomxWeb.Telemetry
    end
  end
end
