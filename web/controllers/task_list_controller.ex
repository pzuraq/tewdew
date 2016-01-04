defmodule Tewdew.TaskListController do
  use Tewdew.Web, :controller

  alias Tewdew.TaskList

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    render conn, model: Repo.all(TaskList)
  end

  def show(conn, %{"id" => id}) do
    task_list = TaskList |> Repo.get!(id) |> Repo.preload [:tasks]
    render conn, model: task_list
  end

  def create(conn, %{"data" => %{"attributes" => attributes}}) do
    changeset = TaskList.changeset(%TaskList{}, attributes)

    case Repo.insert(changeset) do
      {:ok, task_list} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", task_list_path(conn, :show, task_list))
        |> render(:show, data: task_list)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def update(conn, %{"id" => id, "data" => %{"attributes" => attributes}}) do
    task_list = Repo.get!(TaskList, id)
    changeset = TaskList.changeset(task_list, attributes)

    case Repo.update(changeset) do
      {:ok, task_list} ->
        conn
        |> render(:show, data: task_list)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task_list = Repo.get!(TaskList, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(task_list)

    send_resp(conn, :no_content, "")
  end
end
