defmodule Attendance.Repo.Migrations.CreateCompany do
  use Ecto.Migration

  def change do
    create table(:companies) do
      add :name, :string
      add :cui, :string
      add :nrc, :string
      add :adresa, :string
      add :localitate, :string
      add :judet, :string
      add :telefon, :string
      add :user_id, references(:users)

      timestamps()
    end

  end
end
