defmodule Tewdew.Repo.Migrations.CreateTask do
  use Ecto.Migration

  def up do
    create table(:tasks, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :task_list_id, :uuid
      add :name, :string
      add :ordinal, :integer
      add :is_complete, :boolean, default: false

      timestamps
    end
  end

  def down do
    drop table(:tasks)
  end
end
