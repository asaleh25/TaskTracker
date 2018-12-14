defmodule TaskTracker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :title, :string
      add :desc, :text
      add :complete, :boolean, default: false, null: false
      add :timespent, :integer
      add :assignedto, references(:users)

      timestamps()
    end

    create index(:tasks, [:assignedto])
  end
end
