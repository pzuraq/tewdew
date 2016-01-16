defmodule Tewdew.Repo.Migrations.CreateBoard do
  use Ecto.Migration

  def up do
    create table(:task_boards, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :user_id, :uuid
      add :name, :string

      timestamps
    end
  end

  def down do
    drop table(:boards)
  end
end
