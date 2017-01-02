defmodule Attendance.Repo.Migrations.CreateAttendance do
  use Ecto.Migration

  def change do
    create table(:attendances) do
      add :employeeID, :integer
      add :device_id, :integer
      add :devicegroup_id, :integer
      add :status, :integer

      timestamps()
    end

  end
end
