defmodule Attendance.Plug.Authenticate do
  import Plug.Conn
  import Attendance.Router.Helpers
  import Phoenix.Controller
  require Logger

 # def put_headers(conn, key_values) do
 #   Enum.reduce key_values, conn, fn {k, v}, conn ->
 #     put_resp_header(conn, to_string(k), v)
 #   end
 # end

 # plug :put_headers, %{content_encoding: "gzip", cache_control: "max-age=3600"}
 # plug :protect_from_forgery

  def init(default), do: default

  def call(conn, default) do
    current_user = get_session(conn, :current_user)
    if current_user do
      session_time = current_user.loggedin - (:calendar.datetime_to_gregorian_seconds(Ecto.DateTime.to_erl(Ecto.DateTime.utc)))
      Logger.warn(session_time)
      if session_time > 43200 do
        delete_session(conn, :current_user)
          |> put_flash(:info, 'Sesiunea a expirat!')
          |> redirect(to: session_path(conn, :new))
      else 
        assign(conn, :current_user, current_user)
      end
    else
      conn
        |> put_flash(:error, 'Trebuie sa te autentifici pentru a avea acces la aceasta pagina!')
        |> redirect(to: session_path(conn, :new))
    end
  end
end
