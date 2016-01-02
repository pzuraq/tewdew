defmodule Tewdew.TaskView do
  use Tewdew.Web, :view

  def render("index.json", %{tasks: tasks}) do
    %{data: render_many(tasks, Tewdew.TaskView, "task.json")}
  end

  def render("show.json", %{task: task}) do
    %{data: render_one(task, Tewdew.TaskView, "task.json")}
  end

  def render("task.json", %{task: task}) do
    %{id: task.id,
      task_list_id: task.task_list_id,
      name: task.name,
      ordinal: task.ordinal,
      is_complete: task.is_complete}
  end
end
