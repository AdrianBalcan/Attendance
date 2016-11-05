defmodule Attendance.FingerprintController do
  use Attendance.Web, :controller

  alias Attendance.Fingerprint

  def index(conn, _params) do
    fingerprints = Repo.all(Fingerprint)
    render(conn, "index.html", fingerprints: fingerprints)
  end

  def new(conn, _params) do
    changeset = Fingerprint.changeset(%Fingerprint{}, _params)
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"fingerprint" => fingerprint_params}) do
    changeset = Fingerprint.changeset(%Fingerprint{}, fingerprint_params)

    case Repo.insert(changeset) do
      {:ok, _fingerprint} ->
        conn
        |> put_flash(:info, "Fingerprint created successfully.")
        |> redirect(to: fingerprint_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    fingerprint = Repo.get!(Fingerprint, id)
    render(conn, "show.html", fingerprint: fingerprint)
  end

  def edit(conn, %{"id" => id}) do
    fingerprint = Repo.get!(Fingerprint, id)
    changeset = Fingerprint.changeset(fingerprint)
    render(conn, "edit.html", fingerprint: fingerprint, changeset: changeset)
  end

  def update(conn, %{"id" => id, "fingerprint" => fingerprint_params}) do
    fingerprint = Repo.get!(Fingerprint, id)
    changeset = Fingerprint.changeset(fingerprint, fingerprint_params)

    case Repo.update(changeset) do
      {:ok, fingerprint} ->
        conn
        |> put_flash(:info, "Fingerprint updated successfully.")
        |> redirect(to: fingerprint_path(conn, :show, fingerprint))
      {:error, changeset} ->
        render(conn, "edit.html", fingerprint: fingerprint, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    fingerprint = Repo.get!(Fingerprint, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(fingerprint)

    conn
    |> put_flash(:info, "Fingerprint deleted successfully.")
    |> redirect(to: fingerprint_path(conn, :index))
  end
end
