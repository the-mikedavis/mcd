defmodule McdWeb.Router do
  use McdWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", McdWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    resources("/ideas", PostController, only: [:index, :show])
    get("/knowledge", TopicController, :index)
    # get "/vigilo", VigiloController, :index
  end

  # scope "/api", McdWeb do
  # pipe_through :api
  #
  # post "/vigilo", VigiloController, :update
  # end
end
