defmodule Attendance.Repo.Migrations.CreateEmployee do
  use Ecto.Migration

  def change do
    create table(:employees) do
      add :firstname, :string
      add :lastname, :string
      add :job, :string
      add :team, :string
      add :dob, :date
      add :active, :boolean, default: false, null: false

      timestamps()
    end

  end
end