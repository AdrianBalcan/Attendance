defmodule Attendance.Password do
  alias Attendance.Repo
  import Ecto.Changeset, only: [put_change: 3]
  import Comeonin.Bcrypt, only: [hashpwsalt: 1]

  require Logger

  @doc """
    Generates a password for the user changeset and stores it to the changeset as encrypted_password.
  """

  def generate_password(changeset) do
    put_change(changeset, :encrypted_password, hashpwsalt(changeset.params["password"]))
  end

  def insert_db(changeset) do
    case Repo.insert(changeset) do
      {:ok, changeset} ->
        Logger.warn("Logging this text!")
      {:error, changeset} ->
        Logger.warn("Loggingaaaathis text!")
    end
    
  end

  @doc """
    Generates the password for the changeset and then stores it to the database.
  """
  def generate_password_and_store_user(changeset) do
    changeset
      |> generate_password
      |> insert_db
  end
end
