defmodule Tewdew.TaskList do
  use Tewdew.Web, :model

  @primary_key {:id, Ecto.UUID, []}

  schema "task_lists" do
    field :user_id, Ecto.UUID
    field :name, :string

    timestamps
  end

  @required_fields ~w(id user_id name)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ nil) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
