defmodule Tewdew.TaskBoardControllerTest do
  use Tewdew.ConnCase

  alias Tewdew.TaskBoard
  @valid_attrs %{id: "7488a646-e31f-11e4-aace-600308960662", name: "some content", user_id: "7488a646-e31f-11e4-aace-600308960662"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    conn = conn
           |> put_req_header("accept", "application/vnd.api+json")
           |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  test "shows chosen resource", %{conn: conn} do
    task_board = Repo.insert! %TaskBoard{id: "7488a646-e31f-11e4-aace-600308960662"}
    conn = get conn, task_board_path(conn, :show, task_board)

    assert json_response(conn, 200)["data"] == %{
      "type" => "task-board",
      "id" => task_board.id,
      "attributes" => %{
        "user-id" => task_board.user_id,
        "name" => task_board.name
      },
      "links" => %{
        "self" => "/api/task-boards/7488a646-e31f-11e4-aace-600308960662"
      },
      "relationships" => %{
        "task-lists" => %{
          "links" => %{
            "related" => "/api/task-boards/7488a646-e31f-11e4-aace-600308960662/task-lists"
          }
        }
      }
    }
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, task_board_path(conn, :show, "1f08a2c1-d801-4869-acfc-031d4c97fe96")
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, task_board_path(conn, :create), data: %{attributes: @valid_attrs}
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(TaskBoard, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, task_board_path(conn, :create), data: %{attributes: @invalid_attrs}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    task_board = Repo.insert! %TaskBoard{id: "7488a646-e31f-11e4-aace-600308960662"}
    conn = put conn, task_board_path(conn, :update, task_board), data: %{attributes: @valid_attrs}
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(TaskBoard, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    task_board = Repo.insert! %TaskBoard{id: "7488a646-e31f-11e4-aace-600308960662"}
    conn = put conn, task_board_path(conn, :update, task_board), data: %{attributes: @invalid_attrs}
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    task_board = Repo.insert! %TaskBoard{id: "7488a646-e31f-11e4-aace-600308960662"}
    conn = delete conn, task_board_path(conn, :delete, task_board)
    assert response(conn, 204)
    refute Repo.get(TaskBoard, task_board.id)
  end
end
