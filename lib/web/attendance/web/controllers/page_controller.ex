defmodule Attendance.PageController do
  use Attendance.Web, :controller
  plug Attendance.Plug.Authenticate

  def index(conn, _params) do
    render conn, "index.html"
  end
end
