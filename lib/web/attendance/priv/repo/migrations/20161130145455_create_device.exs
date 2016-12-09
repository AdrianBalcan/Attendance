defmodule Attendance.Repo.Migrations.CreateDevice do
  use Ecto.Migration

  def change do
    create table(:devices) do
      add :hw, :text
      add :userID, :integer
      add :expire, :date

      timestamps()
    end

  end
end
