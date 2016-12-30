defmodule Attendance.Repo.Migrations.CreateFingerprint do
  use Ecto.Migration

  def change do
    create table(:fingerprints) do
      add :f_id, :integer
      add :employeeID, :integer
      add :template, :binary
      add :active, :boolean, default: false, null: false

      timestamps()
    end

  end
end
