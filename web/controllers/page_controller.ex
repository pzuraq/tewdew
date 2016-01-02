defmodule Tewdew.PageController do
  use Tewdew.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
