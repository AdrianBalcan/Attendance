defmodule Attendance.AttendanceController do
  use Attendance.Web, :controller

  plug Attendance.Plug.Authenticate
  alias Attendance.Employee
  alias Attendance.DeviceGroup
  alias Attendance.Attendance

  def index(conn, params) do
    limit = 25
    
    current_user_id = get_session(conn, :current_user).id
   # from = params["from"]
   # to = params["to"]
   # IO.inspect from
   # IO.inspect to
   # IO.inspect Ecto.Date.from_erl({2017, 01, 01})

    selectEmployees = Repo.all(from e in Employee, join: dg in DeviceGroup, on: e.devicegroups_id == dg.id, select: {fragment("? || ' ' || ?", e.firstname, e.lastname), e.id}, where: dg.user_id == ^current_user_id)

    query = from a in Attendance, join: e in Employee, on: a.employeeID == e.id,
      join: dg in DeviceGroup, on: e.devicegroups_id == dg.id, 
      select: %{id: a.employeeID, firstname: e.firstname, lastname: e.lastname,
        device: a.device_hw, devicegroup: a.devicegroup_id,
        timestamp: a.inserted_at, status: a.status}, 
      where: dg.user_id == ^current_user_id,
      #where: a.inserted_at > type(^Ecto.Date.from_erl({2017, 01, 01}), Ecto.Date),
      order_by: [desc: a.inserted_at]

    query = if Map.has_key?(params, "e") do
      case Float.parse(params["e"]) do
        {_num, ""} -> from q in query, where: q.employeeID == ^params["e"]
        {_num, _r} -> query          # _r : remainder_of_bianry
        :error     -> query
      end
    else 
      query
    end

    query = if Map.has_key?(params, "f") do
      from = params["f"]
        |> Timex.parse!("%Y-%m-%d", :strftime)
        |> Ecto.Date.cast!
      from q in query, where: q.inserted_at >= type(^from, Ecto.Date)
    else 
      query
    end

    query = if Map.has_key?(params, "t") do
      to = params["t"]
        |> Timex.parse!("%Y-%m-%d", :strftime)
        |> Ecto.Date.cast!
      from q in query, where: q.inserted_at < date_add(^to, 1, "day") 
    else 
      query
    end


    countAttendances = Repo.aggregate(query,  :count, :id)
    totalPages = countAttendances / limit
    currentPage = if Map.has_key?(params, "p") do
      case Float.parse(params["p"]) do
        {_num, ""} -> 
          {currentPage, _} = Integer.parse(params["p"])
          currentPage-1
        {_num, _r} -> 0          # _r : remainder_of_bianry
        :error     -> 0
      end
    else 
      0
    end

    selectedEmployee = if Map.has_key?(params, "e") do
      case Float.parse(params["e"]) do
        {_num, ""} -> 
          {parse, _} = Integer.parse(params["e"])
          parse
        {_num, _r} -> 0          # _r : remainder_of_bianary
        :error     -> 0
      end
    else 
      0
    end

    dataQuery = from q in query, 
      limit: ^limit, offset: ^(limit*currentPage)
    attendances = Repo.all(dataQuery)

    render(conn, "index.html", attendances: attendances,
      selectEmployees: selectEmployees,
      selectedEmployee: selectedEmployee,
      currentPage: currentPage+1, totalPages: totalPages)
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
