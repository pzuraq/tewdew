defmodule Tewdew.Router do
  use Tewdew.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    # plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Tewdew do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", Tewdew do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]

    resources "/task-lists", TaskListController, except: [:new, :edit]
    resources "/tasks", TaskController, except: [:new, :edit]
  end
end
