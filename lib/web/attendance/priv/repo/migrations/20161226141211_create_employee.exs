defmodule Attendance.Repo.Migrations.CreateEmployee do
  use Ecto.Migration

  def change do
    create table(:employees) do
      add :firstname, :string
      add :lastname, :string
      add :companies_id, references(:companies) 
      add :devicegroups_id, references(:devicegroups) 
      add :phone, :string
      add :job, :string
      add :team, :string
      add :dob, :date
      add :active, :boolean, default: true, null: false

      timestamps()
    end

  end
end
