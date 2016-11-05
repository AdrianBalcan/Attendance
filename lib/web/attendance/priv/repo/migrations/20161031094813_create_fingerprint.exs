defmodule Attendance.Repo.Migrations.CreateFingerprint do
  use Ecto.Migration

  def change do
    create table(:fingerprints) do
      add :employeeID, :integer
      add :template, :string
      add :active, :boolean, default: false, null: false

      timestamps()
    end

  end
end
