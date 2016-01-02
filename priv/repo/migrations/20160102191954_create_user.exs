defmodule Tewdew.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def up do
    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v4()")
      add :email, :string
      add :password, :string

      timestamps
    end
  end

  def down do
    drop table(:users)
  end
end
