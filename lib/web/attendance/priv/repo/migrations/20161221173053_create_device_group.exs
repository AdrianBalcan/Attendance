defmodule Attendance.Repo.Migrations.CreateDeviceGroup do
  use Ecto.Migration

  def change do
    create table(:devicegroups) do
      add :name, :string
      add :employee_max_fingerprints, :integer
      add :fingerprints_limit, :integer
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end
    create index(:devicegroups, [:user_id])

  end
end
