defmodule Tewdew.TaskBoardView do
  use JaSerializer.PhoenixView

  location "/api/task-boards/:id"
  attributes [:name, :user_id]

  has_many :task_lists, link: "/api/task-boards/:id/task-lists"

  def type, do: "task-board"
end
