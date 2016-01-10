defmodule Tewdew.TaskListView do
  use JaSerializer.PhoenixView

  location "/api/task-lists/:id"
  attributes [:name, :user_id]

  has_many :tasks, link: "/api/task-lists/:id/tasks"

  def type, do: "task-list"
end
