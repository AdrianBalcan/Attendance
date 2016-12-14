defmodule Attendance.PageController do
  use Attendance.Web, :controller
  plug Attendance.Plug.Authenticate
  require Logger
#  plug :secure_cache_headers
#  plug :resp_headers
  #plug :testtt

  def prepend_response_header(conn, _) do
    #Plug.Conn.resp_headers(conn, [{"Cache-Control", "max-age=60"} | conn.resp_headers])
  end
  defp testtt(conn, _) do
    Plug.Conn.put_resp_header(conn, "Keep-Alive", "timeout=1, max=2")
    Plug.Conn.delete_resp_header(conn, "Cache-Control")
    Plug.Conn.put_resp_header(conn, "Cache-Control", "max-age=66")
    Plug.Conn.delete_resp_header(conn, "Keep-Alive")
    Plug.Conn.put_resp_header(conn, "Keep-Alive", "timeout=1, max=3")
  end
#  defp secure_cache_headers(conn, _) do
    #Plug.Conn.delete_resp_header(conn, "Cache-Control")
#    Plug.Conn.delete_req_header(conn, "Cache-Control")
#    Plug.Conn.put_resp_header(conn, "Keep-Alive", "timeout=1, max=2")
  #  Plug.Conn.put_resp_header(conn, "pragma", "no-cache")
#  end

  def index(conn, _params) do
    render conn, "index.html"
   # current_user = get_session(conn, :current_user)
   # Logger.warn(current_user)
  end
end
