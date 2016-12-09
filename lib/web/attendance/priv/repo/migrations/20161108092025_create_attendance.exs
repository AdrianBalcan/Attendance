defmodule Attendance.Repo.Migrations.CreateAttendance do
  use Ecto.Migration

  def change do
    create table(:attendances) do
      add :employeeID, :integer

      timestamps()
    end

  end
end