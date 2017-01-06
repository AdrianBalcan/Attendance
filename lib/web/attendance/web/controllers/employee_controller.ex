defmodule Attendance.EmployeeController do
  use Attendance.Web, :controller

  plug Attendance.Plug.Authenticate
  alias Attendance.Employee
  alias Attendance.Company

  def index(conn, _params) do
    IO.inspect "asfsadfasdfasdfjkhasfkjhaskjfhaskjdfhsdf"
    current_user_id = get_session(conn, :current_user).id
    employees = Repo.all(from e in Attendance.Employee, join: c in Company, on: e.companies_id == c.id, where: c.user_id == ^current_user_id)
    render(conn, "index.html", employees: employees)
  end

  def new(conn, _params) do
    current_user_id = get_session(conn, :current_user).id
    companies = Repo.all(from f in Attendance.Company, [select: {f.name, f.id}, where: f.user_id == ^current_user_id])
    devicegroups = Repo.all(from dg in Attendance.DeviceGroup, [select: {dg.id, dg.id}, where: dg.user_id == ^current_user_id])
    changeset = Employee.changeset(%Employee{})
    render(conn, "new.html", changeset: changeset, companies: companies, devicegroups: devicegroups)
  end

  def create(conn, %{"employee" => employee_params}) do
    current_user_id = get_session(conn, :current_user).id
    changeset = Employee.changeset(%Employee{}, employee_params)
    case Repo.insert(changeset) do
      {:ok, employee} ->
        conn
        |> put_flash(:info, "Angajatul a fost adaugat!")
        |> redirect(to: employee_path(conn, :show, employee))
      {:error, changeset} ->
        devicegroups = Repo.all(from dg in Attendance.DeviceGroup, [select: {dg.id, dg.id}, where: dg.user_id == ^current_user_id])
        companies = Repo.all(from f in Attendance.Company, [select: {f.name, f.id}, where: f.user_id == ^current_user_id])
        render(conn, "new.html", changeset: changeset, companies: companies, devicegroups: devicegroups)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user_id = get_session(conn, :current_user).id
    [employee] = Repo.all(from e in Attendance.Employee, join: c in Company, on: e.companies_id == c.id, select: %{id: e.id, firstname: e.firstname, lastname: e.lastname, phone: e.phone, companies_id: e.companies_id, devicegroups_id: e.devicegroups_id, job: e.job, team: e.team, dob: e.dob, active: e.active, user_id: c.user_id, inserted_at: e.inserted_at, updated_at: e.updated_at}, where: e.id == ^id)
    if(to_string(employee.user_id) == to_string(current_user_id)) do
      fingerprints = Repo.all(from f in Attendance.Fingerprint, where: f.employeeID == ^id)
      changeset = Attendance.Fingerprint.changeset(%Attendance.Fingerprint{})
      devices = Repo.all(from d in Attendance.Device, [select: {d.hw, d.hw}, where: d.devicegroup_id == ^employee.devicegroups_id])
      action = fingerprint_path(conn, :create)
      cancelEnrollmentAction = fingerprint_path(conn, :cancelEnrollment)
      render(conn, "show.html", changeset: changeset, cancelEnrollmentAction: cancelEnrollmentAction, action: action, id: id, fingerprints: fingerprints, employee: employee, devices: devices)
    else
      redirect(conn, to: employee_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}) do
    current_user_id = get_session(conn, :current_user).id
    [secure] = Repo.all(from e in Attendance.Employee, join: c in Company, on: e.companies_id == c.id, select: c.user_id, where: e.id == ^id)
    if secure != current_user_id do
      conn
      |> put_flash(:error, "Eroare la modificarea datelor! Incearca din nou!")
      |> redirect(to: employee_path(conn, :index))
    else
      companies = Repo.all(from c in Attendance.Company, [select: {c.name, c.id}, where: c.user_id == ^current_user_id])
      devicegroups = Repo.all(from dg in Attendance.DeviceGroup, [select: {dg.id, dg.id}, where: dg.user_id == ^current_user_id])
      employee = Repo.get!(Employee, id)
      changeset = Employee.changeset(employee)
      render(conn, "edit.html", employee: employee, changeset: changeset, companies: companies, devicegroups: devicegroups)
    end
  end

  def update(conn, %{"id" => id, "employee" => employee_params}) do
    current_user_id = get_session(conn, :current_user).id
    companies_id = employee_params["companies_id"]
    [companies] = Repo.all(from c in Attendance.Company, select: c.user_id, where: c.id == ^companies_id)
    if(current_user_id == companies) do
      employee = Repo.get!(Employee, id)
      changeset = Employee.changeset(employee, employee_params)

      case Repo.update(changeset) do
        {:ok, employee} ->
          conn
          |> put_flash(:info, "Datele au fost modificate!")
          |> redirect(to: employee_path(conn, :show, employee))
        {:error, changeset} ->
          render(conn, "edit.html", employee: employee, changeset: changeset)
      end
    else
      conn
      |> put_flash(:error, "Eroare la modificarea datelor! Incearca din nou!")
      |> redirect(to: employee_path(conn, :index))
    end
  end

#  def delete(conn, %{"id" => id}) do
#    employee = Repo.get!(Employee, id)
#
#    # Here we use delete! (with a bang) because we expect
#    # it to always work (and if it does not, it will raise).
#    Repo.delete!(employee)
#
#    conn
#    |> put_flash(:info, "Employee deleted successfully.")
#    |> redirect(to: employee_path(conn, :index))
#  end
end
