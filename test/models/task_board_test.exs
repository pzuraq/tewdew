defmodule Tewdew.TaskBoardTest do
  use Tewdew.ModelCase

  alias Tewdew.TaskBoard

  @valid_attrs %{id: "7488a646-e31f-11e4-aace-600308960662", name: "some content", user_id: "7488a646-e31f-11e4-aace-600308960662"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = TaskBoard.changeset(%TaskBoard{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = TaskBoard.changeset(%TaskBoard{}, @invalid_attrs)
    refute changeset.valid?
  end
end
