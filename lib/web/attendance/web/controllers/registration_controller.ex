defmodule Attendance.RegistrationController do
  use Attendance.Web, :controller
  
#  plug Attendance.Plug.Authenticate
  alias Attendance.Password

  require Logger
  plug :put_layout, "public.html"
  plug :scrub_params, "user" when action in [:create]
#  plug :action

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render conn, changeset: changeset
  end

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)
    if changeset.valid? do
      changeset = (Password.generate_password(changeset))
      case Repo.insert(changeset) do
        {:ok, changeset} ->
          conn
            |> put_flash(:info, "Contul dumneavoastra a fost creat!")
            |> redirect(to: session_path(conn, :new))
        {:error, changeset} ->
          conn
            |> put_flash(:info, "Un cont cu aceasta adresa de email exista deja!")
            |> render("new.html", changeset: changeset)
      end
    else
      render conn, "new.html", changeset: changeset
    end
  end
end
