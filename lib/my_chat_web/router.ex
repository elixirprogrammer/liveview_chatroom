defmodule MyChatWeb.Router do
  use MyChatWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MyChatWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MyChatWeb do
    pipe_through :browser

    live "/", PageLive
    live "/:room", RoomLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", MyChatWeb do
  #   pipe_through :api
  # end
end
