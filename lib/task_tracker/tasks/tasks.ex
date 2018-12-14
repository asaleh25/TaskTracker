defmodule TaskTracker.Tasks do
  @moduledoc """
  The Tasks context.
  """

  import Ecto.Query, warn: false
  alias TaskTracker.Repo

  alias TaskTracker.Tasks.Task

  @doc """
  Returns the list of tasks.

  ## Examples

      iex> list_tasks()
      [%Task{}, ...]

  """
  def list_tasks do
    Repo.all(Task)
  end

  def get_email(task) do
    case task.assignedto do
      nil -> nil
      user_id -> TaskTracker.Users.get_user!(user_id).email
    end
  end

  @doc """
  Gets a single task.

  Raises `Ecto.NoResultsError` if the Task does not exist.

  ## Examples

      iex> get_task!(123)
      %Task{}

      iex> get_task!(456)
      ** (Ecto.NoResultsError)

  """
  def get_task!(id), do: Repo.get!(Task, id)

  @doc """
  Creates a task.

  ## Examples

      iex> create_task(%{field: value})
      {:ok, %Task{}}

      iex> create_task(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_task(attrs \\ %{}) do
    case assign_task(attrs) do
      attrs -> %Task{}
      |> Task.changeset(attrs)
      |> Repo.insert()
    end
  end

  def assign_task(attrs) do
    case Map.get(attrs, "assigned_to") do
      nil -> attrs
      "" -> attrs
      email -> user = Users.get_user_by_name(email)
      case user do
        nil -> :error
        found -> Map.put(attrs, "assignedto", found.id)
      end
    end
  end

  @doc """
  Updates a task.

  ## Examples

      iex> update_task(task, %{field: new_value})
      {:ok, %Task{}}

      iex> update_task(task, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_task(%Task{} = task, attrs) do
    case assign_task(attrs) do
      :error -> {:error, Ecto.Changeset.add_error(Task.changeset(%Task{}, attrs), :assign_to, "User Not Found")}
      attrs -> task
      |> Task.changeset(attrs)
      |> Repo.update()
    end
  end

  @doc """
  Deletes a Task.

  ## Examples

      iex> delete_task(task)
      {:ok, %Task{}}

      iex> delete_task(task)
      {:error, %Ecto.Changeset{}}

  """
  def delete_task(%Task{} = task) do
    Repo.delete(task)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking task changes.

  ## Examples

      iex> change_task(task)
      %Ecto.Changeset{source: %Task{}}

  """
  def change_task(%Task{} = task) do
    Task.changeset(task, %{})
  end
end
