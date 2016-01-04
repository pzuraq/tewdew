defmodule Tewdew.TaskListControllerTest do
  use Tewdew.ConnCase

  alias Tewdew.TaskList
  @valid_attrs %{id: "7488a646-e31f-11e4-aace-600308960662", name: "some content", user_id: "7488a646-e31f-11e4-aace-600308960662"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    conn = conn
           |> put_req_header("accept", "application/vnd.api+json")
           |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, task_list_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    task_list = Repo.insert! %TaskList{id: "7488a646-e31f-11e4-aace-600308960662"}
    conn = get conn, task_list_path(conn, :show, task_list)
    assert json_response(conn, 200)["data"] == %{
      "type" => "tasklist",
      "id" => task_list.id,
      "attributes" => %{
        "user-id" => task_list.user_id,
        "name" => task_list.name
      },
      "links" => %{
        "self" => "/api/task-lists/7488a646-e31f-11e4-aace-600308960662"
      },
      "relationships" => %{
        "tasks" => %{
          "links" => %{
            "related" => "/api/task-lists/7488a646-e31f-11e4-aace-600308960662/tasks"
          }
        }
      }
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, task_list_path(conn, :show, "1f08a2c1-d801-4869-acfc-031d4c97fe96")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, task_list_path(conn, :create), data: %{attributes: @valid_attrs}
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(TaskList, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, task_list_path(conn, :create), data: %{attributes: @invalid_attrs}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    task_list = Repo.insert! %TaskList{id: "7488a646-e31f-11e4-aace-600308960662"}
    conn = put conn, task_list_path(conn, :update, task_list), data: %{attributes: @valid_attrs}
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(TaskList, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    task_list = Repo.insert! %TaskList{id: "7488a646-e31f-11e4-aace-600308960662"}
    conn = put conn, task_list_path(conn, :update, task_list), data: %{attributes: @invalid_attrs}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    task_list = Repo.insert! %TaskList{id: "7488a646-e31f-11e4-aace-600308960662"}
    conn = delete conn, task_list_path(conn, :delete, task_list)
    assert response(conn, 204)
    refute Repo.get(TaskList, task_list.id)
  end
end
