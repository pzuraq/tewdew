defmodule Tewdew.Repo.Migrations.CreateTaskList do
  use Ecto.Migration

  def up do
    create table(:task_lists, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :task_board_id, :uuid
      add :name, :string

      timestamps
    end
  end

  def down do
    drop table(:task_lists)
  end
end
