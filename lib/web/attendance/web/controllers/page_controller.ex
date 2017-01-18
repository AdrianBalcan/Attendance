defmodule Attendance.PageController do
  use Attendance.Web, :controller
  plug Attendance.Plug.Authenticate

  def index(conn, _params) do
    employeesStatus = Repo.all(from a in Attendance.Attendance, join: e in Attendance.Employee ,on: a.employeeID == e.id, select: %{firstname: e.firstname, lastname: e.lastname, employeeID: a.employeeID, status: a.status, inserted_at: a.inserted_at}, distinct: a.employeeID, order_by: [desc: :id])
    render(conn, "index.html", employeesStatus: employeesStatus)
  end
end
