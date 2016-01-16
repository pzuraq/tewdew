defmodule Tewdew.TaskListControllerTest do
  use Tewdew.ConnCase

  alias Tewdew.TaskBoard
  alias Tewdew.TaskList
  alias Tewdew.Task
  @valid_attrs %{id: "7488a646-e31f-11e4-aace-600308960662", name: "some content", task_board_id: "96e75730-6e17-4c28-be8d-5ec6db01e85e"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    conn = conn
           |> put_req_header("accept", "application/vnd.api+json")
           |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    task_list = Repo.insert! %TaskList{id: "7488a646-e31f-11e4-aace-600308960662", task_board_id: "96e75730-6e17-4c28-be8d-5ec6db01e85e"}
    task = Repo.insert! %Task{id: "571f64c4-e013-4ea0-a2f2-615c0944a38d", task_list_id: "7488a646-e31f-11e4-aace-600308960662"}

    conn = get conn, Tewdew.Router.Helpers.task_board_task_list_path(conn, :index, "96e75730-6e17-4c28-be8d-5ec6db01e85e")
    response = json_response(conn, 200)

    assert response["data"] == [
      %{
        "type" => "task-list",
        "id" => task_list.id,
        "attributes" => %{
          "task-board-id" => task_list.task_board_id,
          "name" => task_list.name
        },
        "links" => %{
          "self" => "/api/task-lists/#{task_list.id}"
        },
        "relationships" => %{
          "tasks" => %{
            "data" => [
              %{
                "type" => "task",
                "id" => task.id
              }
            ]
          }
        }
      }
    ]

    assert response["included"] == [
      %{
        "type" => "task",
        "links" => %{
          "self" => "/api/tasks/#{task.id}"
        },
        "id" => task.id,
        "attributes" => %{
          "task-list-id" => task_list.id,
          "ordinal" => task.ordinal,
          "name" => task.name,
          "is-complete" => task.is_complete
        }
      }
    ]
  end


  test "shows chosen resource", %{conn: conn} do
    task_list = Repo.insert! %TaskList{id: "7488a646-e31f-11e4-aace-600308960662"}
    task = Repo.insert! %Task{id: "571f64c4-e013-4ea0-a2f2-615c0944a38d", task_list_id: "7488a646-e31f-11e4-aace-600308960662"}

    conn = get conn, task_list_path(conn, :show, task_list)
    response = json_response(conn, 200)

    assert response["data"] == %{
      "type" => "task-list",
      "id" => task_list.id,
      "attributes" => %{
        "task-board-id" => task_list.task_board_id,
        "name" => task_list.name
      },
      "links" => %{
        "self" => "/api/task-lists/#{task_list.id}"
      },
      "relationships" => %{
        "tasks" => %{
          "data" => [
            %{
              "type" => "task",
              "id" => task.id
            }
          ]
        }
      }
    }

    assert response["included"] == [
      %{
        "type" => "task",
        "links" => %{
          "self" => "/api/tasks/#{task.id}"
        },
        "id" => task.id,
        "attributes" => %{
          "task-list-id" => task_list.id,
          "ordinal" => task.ordinal,
          "name" => task.name,
          "is-complete" => task.is_complete
        }
      }
    ]
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
