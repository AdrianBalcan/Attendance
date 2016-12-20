defmodule Attendance.EmployeeController do
  use Attendance.Web, :controller

  plug Attendance.Plug.Authenticate
  alias Attendance.Employee
  alias Attendance.Company
  alias Attendance.Fingerprint

  def index(conn, _params) do
    current_user_id = get_session(conn, :current_user).id
    employees = Repo.all(from e in Attendance.Employee, join: c in Company, on: e.companies_id == c.id, where: c.user_id == ^current_user_id)
    render(conn, "index.html", employees: employees)
  end

  def new(conn, _params) do
    current_user_id = get_session(conn, :current_user).id
    companies = Repo.all(from f in Attendance.Company, [select: {f.name, f.id}, where: f.user_id == ^current_user_id])
    changeset = Employee.changeset(%Employee{})
    render(conn, "new.html", changeset: changeset, companies: companies)
  end

  def create(conn, %{"employee" => employee_params}) do
    current_user_id = get_session(conn, :current_user).id
    employee_params = Map.put(employee_params, "user_id", to_string(current_user_id))
    changeset = Employee.changeset(%Employee{}, employee_params)

    case Repo.insert(changeset) do
      {:ok, employee} ->
        conn
        |> put_flash(:info, "Employee created successfully.")
        |> redirect(to: employee_path(conn, :show, employee))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user_id = get_session(conn, :current_user).id
    [employee] = Repo.all(from e in Attendance.Employee, join: c in Company, on: e.companies_id == c.id, select: %{id: e.id, firstname: e.firstname, lastname: e.lastname, companies_id: e.companies_id, job: e.job, team: e.team, dob: e.dob, active: e.active, user_id: c.user_id, inserted_at: e.inserted_at, updated_at: e.updated_at}, where: e.id == ^id)
    if(to_string(employee.user_id) == to_string(current_user_id)) do
      fingerprints = Repo.all(from f in Attendance.Fingerprint, where: f.employeeID == ^id)
      render(conn, "show.html", id: id, fingerprints: fingerprints, employee: employee)
    else
      redirect(conn, to: employee_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}) do
    employee = Repo.get!(Employee, id)
    changeset = Employee.changeset(employee)
    current_user_id = get_session(conn, :current_user).id
    companies = Repo.all(from f in Attendance.Company, [select: {f.name, f.id}, where: f.user_id == ^current_user_id])
    render(conn, "edit.html", employee: employee, changeset: changeset, companies: companies)
  end

  def update(conn, %{"id" => id, "employee" => employee_params}) do
    employee = Repo.get!(Employee, id)
    changeset = Employee.changeset(employee, employee_params)

    case Repo.update(changeset) do
      {:ok, employee} ->
        conn
        |> put_flash(:info, "Employee updated successfully.")
        |> redirect(to: employee_path(conn, :show, employee))
      {:error, changeset} ->
        render(conn, "edit.html", employee: employee, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    employee = Repo.get!(Employee, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(employee)

    conn
    |> put_flash(:info, "Employee deleted successfully.")
    |> redirect(to: employee_path(conn, :index))
  end
end
