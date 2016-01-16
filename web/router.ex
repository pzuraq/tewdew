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
    plug :accepts, ["json-api"]
    # plug JaSerializer.ContentTypeNegotiation
    # plug JaSerializer.Deserializer
  end

  scope "/", Tewdew do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", Tewdew do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit, :index]

    resources "/task-boards", TaskBoardController, except: [:new, :edit, :index] do
      get "/task-lists", TaskListController, :index
    end

    resources "/task-lists", TaskListController, except: [:new, :edit, :index]

    resources "/tasks", TaskController, except: [:new, :edit, :index]
  end
end
