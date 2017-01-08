defmodule Attendance.Repo.Migrations.CreateAttendance do
  use Ecto.Migration

  def change do
    create table(:attendances) do
      add :employeeID, :integer
      add :f_id, :integer
      add :device_hw, :string
      add :devicegroup_id, :integer
      add :status, :string

      timestamps()
    end

  end
end
