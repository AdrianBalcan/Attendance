defmodule Attendance.FingerprintController do
  use Attendance.Web, :controller

  plug Attendance.Plug.Authenticate
  alias Attendance.Fingerprint

  def index(conn, _params) do
    fingerprints = Repo.all(Fingerprint)
    render(conn, "index.html", fingerprints: fingerprints)
  end

#  def new(conn, %{"employeeID" => employeeID, "firstname" => firstname, "lastname" => lastname}) do
    #Attendance.Endpoint.broadcast "sp:NzA4MzUwMDE4NjQxNzI=0", "new:msg", %{"response" => %{"type" => "enroll", "employeeID" => employeeID, "firstname" => firstname, "lastname" => lastname}}
   #    body = "{\"name\": \"#{firstname} #{lastname}\", \"employeeID\": \"#{employeeID}\"}"

   # response = HTTPotion.post("http://pontaj-s01.zog.ro/enroll", [body: body, headers: ["Content-Type": "application/json"]])
    
   # cond do
   #   String.contains?(response, "200") ->
   #   true ->
   #     put_flash(conn, :danger, "Eroare! Nu este conexiune cu statia!")
   # end
#    conn
#    |> put_flash(:info, "Statia este pregatita pentru inregistrarea angajatului.")
#    |> redirect(to: employee_path(conn, :show, employeeID))
#  end

  def create(conn, %{"fingerprint" => fingerprint_params}) do
#    changeset = Fingerprint.changeset(%Fingerprint{}, fingerprint_params)

     Attendance.Endpoint.broadcast "sp:" <> fingerprint_params["device"], "new:msg", %{"response" => %{"type" => "enroll", "employeeID" => fingerprint_params["employeeID"], "firstname" => fingerprint_params["firstname"], "lastname" => fingerprint_params["lastname"]}}
 
       conn
       |> put_flash(:info, "Statia este pregatita pentru inregistrarea angajatului.")
       |> redirect(to: employee_path(conn, :show, fingerprint_params["employeeID"]))
#    case Repo.insert(changeset) do
#      {:ok, _fingerprint} ->
#        conn
#        |> put_flash(:info, "Fingerprint created successfully.")
#        |> redirect(to: fingerprint_path(conn, :index))
#      {:error, changeset} ->
#        render(conn, "new.html", changeset: changeset)
#    end
  end

  def cancelEnrollment(conn, %{"fingerprint" => fingerprint_params}) do

     Attendance.Endpoint.broadcast "sp:" <> fingerprint_params["device"], "new:msg", %{"response" => %{"type" => "cancelEnrollment", "employeeID" => fingerprint_params["employeeID"], "firstname" => fingerprint_params["firstname"], "lastname" => fingerprint_params["lastname"]}}
 
       conn
       |> put_flash(:info, "Inregistrarea angajatului a fost anulata.")
       |> redirect(to: employee_path(conn, :show, fingerprint_params["employeeID"]))
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
    current_user_id = get_session(conn, :current_user).id
    devices = Repo.all(from dg in Attendance.DeviceGroup, join: d in Attendance.Device, on: dg.id == d.devicegroup_id, select: d.hw, where: dg.user_id == ^current_user_id)
    fingerprint = Repo.get!(Fingerprint, id)
    for device <- devices, do:
      Attendance.Endpoint.broadcast "sp:" <> device, "new:msg", %{"response" => %{"type" => "deleteFingerprint", "id" => fingerprint.f_id}}


    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(fingerprint)

    conn
    |> put_flash(:info, "Amprenta a fost stearsa!")
    |> redirect(to: employee_path(conn, :show, fingerprint.employeeID))
  end
end
