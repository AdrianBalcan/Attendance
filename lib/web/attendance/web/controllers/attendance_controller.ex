defmodule Attendance.AttendanceController do
  use Attendance.Web, :controller

  plug Attendance.Plug.Authenticate
  alias Attendance.Employee
  alias Attendance.Attendance

  def index(conn, _params) do
    current_user_id = get_session(conn, :current_user).id
    attendances = Repo.all(from a in Attendance, join: e in Employee, on: a.employeeID == e.id, select: %{id: a.employeeID, firstname: e.firstname, lastname: e.lastname, device: a.device_hw, devicegroup: a.devicegroup_id, timestamp: a.inserted_at, status: a.status}, order_by: [desc: a.inserted_at])
    #attendances = Repo.all(Attendance)
    render(conn, "index.html", attendances: attendances)
  end

  def new(conn, _params) do
    changeset = Attendance.changeset(%Attendance{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"attendance" => attendance_params}) do
    IO.inspect attendance_params
    changeset = Attendance.changeset(%Attendance{}, attendance_params)
    IO.inspect changeset

    case Repo.insert(changeset) do
      {:ok, _attendance} ->
        conn
        |> put_flash(:info, "Attendance created successfully.")
        |> redirect(to: attendance_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    attendance = Repo.get!(Attendance, id)
    render(conn, "show.html", attendance: attendance)
  end

  def edit(conn, %{"id" => id}) do
    attendance = Repo.get!(Attendance, id)
    changeset = Attendance.changeset(attendance)
    render(conn, "edit.html", attendance: attendance, changeset: changeset)
  end

  def update(conn, %{"id" => id, "attendance" => attendance_params}) do
    attendance = Repo.get!(Attendance, id)
    changeset = Attendance.changeset(attendance, attendance_params)

    case Repo.update(changeset) do
      {:ok, attendance} ->
        conn
        |> put_flash(:info, "Attendance updated successfully.")
        |> redirect(to: attendance_path(conn, :index))
      {:error, changeset} ->
        render(conn, "edit.html", attendance: attendance, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    attendance = Repo.get!(Attendance, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(attendance)

    conn
    |> put_flash(:info, "Attendance deleted successfully.")
    |> redirect(to: attendance_path(conn, :index))
  end
end
