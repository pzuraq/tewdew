defmodule Tewdew.Task do
  use Tewdew.Web, :model

  @primary_key {:id, Ecto.UUID, []}

  schema "tasks" do
    field :task_list_id, Ecto.UUID
    field :name, :string
    field :ordinal, :integer
    field :is_complete, :boolean, default: false

    timestamps
  end

  @required_fields ~w(id task_list_id name ordinal is_complete)
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
