defmodule Tewdew.TaskView do
  use JaSerializer.PhoenixView

  location "/api/tasks/:id"
  attributes [:task_list_id, :name, :ordinal, :is_complete]
end
