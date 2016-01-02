defmodule Tewdew.UserTest do
  use Tewdew.ModelCase

  alias Tewdew.User

  @valid_attrs %{email: "some content", id: "7488a646-e31f-11e4-aace-600308960662", password: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
