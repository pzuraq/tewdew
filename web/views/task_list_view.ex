defmodule Tewdew.TaskListView do
  use Tewdew.Web, :view

  def render("index.json", %{task_lists: task_lists}) do
    %{data: render_many(task_lists, Tewdew.TaskListView, "task_list.json")}
  end

  def render("show.json", %{task_list: task_list}) do
    %{data: render_one(task_list, Tewdew.TaskListView, "task_list.json")}
  end

  def render("task_list.json", %{task_list: task_list}) do
    %{id: task_list.id,
      user_id: task_list.user_id,
      name: task_list.name}
  end
end
