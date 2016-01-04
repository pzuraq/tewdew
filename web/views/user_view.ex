defmodule Tewdew.UserView do
  use JaSerializer.PhoenixView

  location "/api/users/:id"
  attributes [:email]

  has_many :task_lists, serializer: Tewdew.TaskListView, include: true

  def task_lists(user, _conn) do
    user.task_lists
  end
end
