defmodule Tewdew.UserControllerTest do
  use Tewdew.ConnCase

  alias Tewdew.User
  @valid_attrs %{email: "some content", id: "7488a646-e31f-11e4-aace-600308960662", password: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    conn = conn
           |> put_req_header("accept", "application/vnd.api+json")
           |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = conn
           |> put_req_header("accept", "application/vnd.api+json")
           |> put_req_header("content-type", "application/vnd.api+json")
           |> get user_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! %User{id: "7488a646-e31f-11e4-aace-600308960662"}
    conn = get conn, user_path(conn, :show, user)
    assert json_response(conn, 200)["data"] == %{
      "type" => "user",
      "id" => user.id,
      "attributes" => %{
        "email" => user.email
      },
      "links" => %{
        "self" => "/api/users/7488a646-e31f-11e4-aace-600308960662"
      },
      "relationships" => %{
        "task-lists" => %{
          "data" => []
        }
      }
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, "1f08a2c1-d801-4869-acfc-031d4c97fe96")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), data: %{attributes: @valid_attrs}
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), data: %{attributes: @invalid_attrs}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user = Repo.insert! %User{id: "7488a646-e31f-11e4-aace-600308960662"}
    conn = put conn, user_path(conn, :update, user), data: %{attributes: @valid_attrs}
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = Repo.insert! %User{id: "7488a646-e31f-11e4-aace-600308960662"}
    conn = put conn, user_path(conn, :update, user), data: %{attributes: @invalid_attrs}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    user = Repo.insert! %User{id: "7488a646-e31f-11e4-aace-600308960662"}
    conn = delete conn, user_path(conn, :delete, user)
    assert response(conn, 204)
    refute Repo.get(User, user.id)
  end
end
