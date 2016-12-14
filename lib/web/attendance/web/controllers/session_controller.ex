defmodule Attendance.SessionController do
  use Attendance.Web, :controller
  require Logger

  def put_headers(conn, key_values) do
    Enum.reduce key_values, conn, fn {k, v}, conn ->
      Plug.Conn.put_resp_header(conn, to_string(k), v)
    end
  end

  plug :put_layout, "public.html"
  plug :scrub_params, "user" when action in [:create]
  #plug :put_resp_header "Cache-Control", "max-age=60, no-store, private")
  #plug :put_headers, %{content_encoding: "gzip", "Cache-Control": "max-age=50"}
  #plug :protect_from_forgery
  #plug :action
  #plug :secure_cache_headers

  defp secure_cache_headers(conn, _) do
    Plug.Conn.put_resp_header(conn, "Keep-Alive", "timeout=1, max=2")
  #  Plug.Conn.put_resp_header(conn, "pragma", "no-cache")
  end

  def new(conn, user_params) do
    current_user = get_session(conn, :current_user)
    if current_user do
      conn
        |> redirect(to: page_path(conn, :index))
    else
      render conn, changeset: User.changeset(%User{})
    end
  end

  def create(conn, %{"user" => user_params}) do
    user = if is_nil(user_params["email"]) do
      nil
    else
      Repo.get_by(User, email: user_params["email"])
    end

    user
      |> sign_in(user_params["password"], conn)
  end

  def delete(conn, _) do
    delete_session(conn, :current_user)
      |> put_flash(:info, 'Sesiune incheiata cu succes!')
      |> redirect(to: session_path(conn, :new))
  end

  defp sign_in(user, password, conn) when is_nil(user) do

    conn
      |> put_flash(:error, 'Ai introdus gresit parola sau adresa de email. Te rog completeaza din nou.')
      |> render("new.html", changeset: User.changeset(%User{}))
  end

  def prepend_response_header(conn, key, value) do
    %{conn | resp_headers: [{key, value} | conn.resp_headers]}
  end

  defp sign_in(user, password, conn) when is_map(user) do
    cond do
      Comeonin.Bcrypt.checkpw(to_string(password), to_string(user.encrypted_password)) ->
        user = Map.put(user, :loggedin, (:calendar.datetime_to_gregorian_seconds(Ecto.DateTime.to_erl(Ecto.DateTime.utc))))
        second_fa = Map.put(user, "2fa", Ecto.DateTime.utc)
        conn
          |> put_session(:current_user, user)
          |> put_session(:second_fa, second_fa)
          |> configure_session(renew: true)
          |> redirect(to: page_path(conn, :index))
      true ->
        conn
          |> put_flash(:error, 'Ai introdus gresit parola sau adresa de email. Te rog completeaza din nou.')
          |> render("new.html", changeset: User.changeset(%User{}))
    end
  end
end
