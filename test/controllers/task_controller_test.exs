defmodule Tewdew.TaskControllerTest do
  use Tewdew.ConnCase

  alias Tewdew.Task
  @valid_attrs %{id: "7488a646-e31f-11e4-aace-600308960662", is_complete: true, ordinal: 42, task_list_id: "7488a646-e31f-11e4-aace-600308960662", name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    conn = conn
           |> put_req_header("accept", "application/vnd.api+json")
           |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, Tewdew.Router.Helpers.task_list_task_path(conn, :index, "7488a646-e31f-11e4-aace-600308960662")
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    task = Repo.insert! %Task{id: "7488a646-e31f-11e4-aace-600308960662"}
    conn = get conn, task_path(conn, :show, task)
    assert json_response(conn, 200)["data"] == %{
      "type" => "task",
      "id" => task.id,
      "attributes" => %{
        "name" => task.name,
        "ordinal" => task.ordinal,
        "is-complete" => task.is_complete,
        "task-list-id" => task.task_list_id
      },
      "links" => %{
        "self" => "/api/tasks/7488a646-e31f-11e4-aace-600308960662"
      }
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, task_path(conn, :show, "1f08a2c1-d801-4869-acfc-031d4c97fe96")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, task_path(conn, :create), data: %{attributes: @valid_attrs}
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Task, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, task_path(conn, :create), data: %{attributes: @invalid_attrs}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    task = Repo.insert! %Task{id: "7488a646-e31f-11e4-aace-600308960662"}
    conn = put conn, task_path(conn, :update, task), data: %{attributes: @valid_attrs}
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Task, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    task = Repo.insert! %Task{id: "7488a646-e31f-11e4-aace-600308960662"}
    conn = put conn, task_path(conn, :update, task), data: %{attributes: @invalid_attrs}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    task = Repo.insert! %Task{id: "7488a646-e31f-11e4-aace-600308960662"}
    conn = delete conn, task_path(conn, :delete, task)
    assert response(conn, 204)
    refute Repo.get(Task, task.id)
  end
end
