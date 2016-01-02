defmodule Tewdew.UserView do
  use Tewdew.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Tewdew.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Tewdew.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      password: user.password}
  end
end
