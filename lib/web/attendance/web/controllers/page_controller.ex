defmodule Attendance.PageController do
  use Attendance.Web, :controller
  plug Attendance.Plug.Authenticate

  def index(conn, _params) do
    employeesStatus = Repo.all(from a in Attendance.Attendance, right_join: e in Attendance.Employee ,on: e.id == a.employeeID, select: %{firstname: e.firstname, lastname: e.lastname, employeeID: a.employeeID, status: a.status, inserted_at: a.inserted_at}, distinct: e.id, order_by: [desc: :id])
    IO.inspect employeesStatus
    render(conn, "index.html", employeesStatus: employeesStatus)
  end
end
