defmodule Tewdew.TaskBoardController do
  use Tewdew.Web, :controller

  alias Tewdew.TaskBoard

  plug :scrub_params, "data" when action in [:create, :update]

  def show(conn, %{"id" => id}) do
    task_board = TaskBoard |> Repo.get!(id) |> Repo.preload [:task_lists]
    render conn, model: task_board
  end

  def create(conn, %{"data" => %{"attributes" => attributes}}) do
    changeset = TaskBoard.changeset(%TaskBoard{}, attributes)

    case Repo.insert(changeset) do
      {:ok, task_board} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", task_board_path(conn, :show, task_board))
        |> render(:show, data: task_board)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def update(conn, %{"id" => id, "data" => %{"attributes" => attributes}}) do
    task_board = Repo.get!(TaskBoard, id)
    changeset = TaskBoard.changeset(task_board, attributes)

    case Repo.update(changeset) do
      {:ok, task_board} ->
        conn
        |> render(:show, data: task_board)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task_board = Repo.get!(TaskBoard, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(task_board)

    send_resp(conn, :no_content, "")
  end
end
