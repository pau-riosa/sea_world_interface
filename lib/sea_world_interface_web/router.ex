defmodule SeaWorldInterfaceWeb.Router do
  use SeaWorldInterfaceWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :app_layout do
    plug(:put_layout, {SeaWorldInterfaceWeb.LayoutView, :app})
  end

  pipeline :game_layout do
    plug(:put_layout, {SeaWorldInterfaceWeb.LayoutView, :game})
  end

  scope "/", SeaWorldInterfaceWeb do
    pipe_through([:browser, :app_layout])

    get "/", PageController, :index
    resources "/channels", ChannelController, except: [:show]
  end

  scope "/", SeaWorldInterfaceWeb do
    pipe_through([:browser, :game_layout])

    get "/channels/:id", ChannelController, :show
  end

  # Other scopes may use custom stacks.
  # scope "/api", SeaWorldInterfaceWeb do
  #   pipe_through :api
  # end
end
