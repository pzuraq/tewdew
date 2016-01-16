defmodule Tewdew.UserController do
  use Tewdew.Web, :controller

  alias Tewdew.User

  plug :scrub_params, "data" when action in [:create, :update]

  def show(conn, %{"id" => id}) do
    user = User |> Repo.get!(id) |> Repo.preload [:task_boards]
    render conn, model: user
  end

  def create(conn, %{"data" => %{"attributes" => attributes}}) do
    changeset = User.changeset(%User{}, attributes)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render(:show, data: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def update(conn, %{"id" => id, "data" => %{"attributes" => attributes}}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, attributes)

    case Repo.update(changeset) do
      {:ok, user} ->
        conn
        |> render(:show, data: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(:errors, data: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end
end
