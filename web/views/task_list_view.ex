defmodule Tewdew.TaskListView do
  use JaSerializer.PhoenixView

  location "/api/task-lists/:id"
  attributes [:name, :task_board_id]

  has_many :tasks, serializer: Tewdew.TaskView, include: true

  def tasks(task_list, _conn) do
    task_list.tasks
  end

  def type, do: "task-list"
end
