defmodule Attendance.Repo.Migrations.CreateDevice do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :location, :string
      add :hw, :string
      add :devicegroup_id, references(:devicegroups, on_delete: :nothing)
      add :fingerprint_max_limit, :integer

      timestamps()
    end

    create unique_index(:devices, [:hw])

  end
end
