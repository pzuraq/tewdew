defmodule Tewdew.TaskListTest do
  use Tewdew.ModelCase

  alias Tewdew.TaskList

  @valid_attrs %{id: "7488a646-e31f-11e4-aace-600308960662", name: "some content", user_id: "7488a646-e31f-11e4-aace-600308960662"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TaskList.changeset(%TaskList{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TaskList.changeset(%TaskList{}, @invalid_attrs)
    refute changeset.valid?
  end
end
