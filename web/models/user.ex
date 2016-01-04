defmodule Tewdew.User do
  use Tewdew.Web, :model

  @primary_key {:id, Ecto.UUID, []}

  schema "users" do
    field :email, :string
    field :password, :string

    has_many :task_lists, Tewdew.TaskList

    timestamps
  end

  @required_fields ~w(id email password)
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
