defmodule Attendance.CompanyController do
  use Attendance.Web, :controller

  plug Attendance.Plug.Authenticate
  alias Attendance.Company

  def index(conn, _params) do
    current_user_id = get_session(conn, :current_user).id
    companies = from(p in Company, where: p.user_id == ^current_user_id) |> Repo.all
    render(conn, "index.html", companies: companies)
  end

  def new(conn, _params) do
    changeset = Company.changeset(%Company{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"company" => company_params}) do
    current_user_id = get_session(conn, :current_user).id
    changeset = Company.changeset(%Company{user_id: current_user_id}, company_params)
    case Repo.insert(changeset) do
      {:ok, _company} ->
        conn
        |> put_flash(:info, "Company created successfully.")
        |> redirect(to: company_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user_id = get_session(conn, :current_user).id
    company = Repo.get!(Company, id)
    if(company.user_id != current_user_id) do
      redirect(conn, to: company_path(conn, :index))
    else
      render(conn, "show.html", company: company)
    end
  end

  def edit(conn, %{"id" => id}) do
    current_user_id = get_session(conn, :current_user).id
    company = Repo.get!(Company, id)
    if(company.user_id != current_user_id) do
      redirect(conn, to: company_path(conn, :index))
    else
      changeset = Company.changeset(company)
      render(conn, "edit.html", company: company, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "company" => company_params}) do
    current_user_id = get_session(conn, :current_user).id
    company = Repo.get!(Company, id)
    if(company.user_id != current_user_id) do
      conn
      |> put_flash(:info, "Eroare la modificarea datelor! Incearca din nou!")
      |> redirect(to: company_path(conn, :index))
    else
      changeset = Company.changeset(company, company_params)
      case Repo.update(changeset) do
        {:ok, company} ->
          conn
          |> put_flash(:info, "Company updated successfully.")
          |> redirect(to: company_path(conn, :show, company))
        {:error, changeset} ->
          render(conn, "edit.html", company: company, changeset: changeset)
      end
    end

  end

#  def delete(conn, %{"id" => id}) do
#    company = Repo.get!(Company, id)
#
#    # Here we use delete! (with a bang) because we expect
#    # it to always work (and if it does not, it will raise).
#    Repo.delete!(company)
#
#    conn
#    |> put_flash(:info, "Company deleted successfully.")
#    |> redirect(to: company_path(conn, :index))
#  end
end
