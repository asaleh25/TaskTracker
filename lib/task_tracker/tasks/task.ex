defmodule TaskTracker.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :complete, :boolean, default: false
    field :desc, :string
    field :timespent, :integer, null: true
    field :title, :string
    field :assignedto, :id

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:title, :desc, :complete, :timespent, :assignedto])
    |> validate_required([:title, :desc, :complete])
  end
end
