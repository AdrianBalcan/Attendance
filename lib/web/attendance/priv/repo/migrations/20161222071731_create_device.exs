defmodule Attendance.Repo.Migrations.CreateDevice do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :hw, :string
      add :devicegroup_id, references(:devicegroups, on_delete: :nothing)

      timestamps()
    end
    create index(:devices, [:devicegroup_id])

  end
end