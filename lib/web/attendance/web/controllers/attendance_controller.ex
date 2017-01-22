defmodule Attendance.AttendanceController do
  use Attendance.Web, :controller

  plug Attendance.Plug.Authenticate
  alias Attendance.Employee
  alias Attendance.DeviceGroup
  alias Attendance.Attendance

  def index(conn, params) do
    limit = 25
    current_user_id = get_session(conn, :current_user).id

    countQuery = from a in Attendance, join: e in Employee, on: a.employeeID == e.id, join: dg in DeviceGroup, on: e.devicegroups_id == dg.id, select: %{id: a.employeeID, firstname: e.firstname, lastname: e.lastname, device: a.device_hw, devicegroup: a.devicegroup_id, timestamp: a.inserted_at, status: a.status}, order_by: [desc: a.inserted_at], where: dg.user_id == ^current_user_id
    countAttendances = Repo.aggregate(countQuery,  :count, :id)
    totalPages = countAttendances / limit
    if Map.has_key?(params, "p") do
       currentPage = case Float.parse(params["p"]) do
         {_num, ""} -> 
           {currentPage, _} = Integer.parse(params["p"])
           currentPage-1
         {_num, _r} -> 0                # _r : remainder_of_bianry
         :error     -> 0
       end
    else 
      currentPage = 0
    end
    query = from a in Attendance, join: e in Employee, on: a.employeeID == e.id, join: dg in DeviceGroup, on: e.devicegroups_id == dg.id, select: %{id: a.employeeID, firstname: e.firstname, lastname: e.lastname, device: a.device_hw, devicegroup: a.devicegroup_id, timestamp: a.inserted_at, status: a.status}, order_by: [desc: a.inserted_at], where: dg.user_id == ^current_user_id, limit: ^limit, offset: ^(limit*currentPage)
    attendances = Repo.all(query)
    render(conn, "index.html", attendances: attendances, currentPage: currentPage+1, totalPages: totalPages)
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
      {:ok, _attendance} ->
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
