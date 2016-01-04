defmodule Tewdew.TaskController do
  use Tewdew.Web, :controller

  alias Tewdew.Task

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, %{"task_list_id" => task_list_id}) do
    tasks = Repo.all(from t in Task, where: t.task_list_id == ^task_list_id)
    render conn, model: tasks
  end

  def show(conn, %{"id" => id}) do
    task = Task |> Repo.get!(id)
    render conn, model: task
  end

  def create(conn, %{"data" => %{"attributes" => attributes}}) do
    changeset = Task.changeset(%Task{}, attributes)

    case Repo.insert(changeset) do
      {:ok, task} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", task_path(conn, :show, task))
        |> render(:show, data: task)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def update(conn, %{"id" => id, "data" => %{"attributes" => attributes}}) do
    task = Repo.get!(Task, id)
    changeset = Task.changeset(task, attributes)

    case Repo.update(changeset) do
      {:ok, task} ->
        conn
        |> render(:show, data: task)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    task = Repo.get!(Task, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(task)

    send_resp(conn, :no_content, "")
  end
end
