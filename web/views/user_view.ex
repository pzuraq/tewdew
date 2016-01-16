defmodule Tewdew.UserView do
  use JaSerializer.PhoenixView

  location "/api/users/:id"
  attributes [:email]

  has_many :task_boards, serializer: Tewdew.TaskBoardView, include: true

  def task_boards(user, _conn) do
    user.task_boards
  end
end
