defmodule Attendance.DeviceGroupController do
  use Attendance.Web, :controller

  plug Attendance.Plug.Authenticate
   
  alias Attendance.DeviceGroup

  def index(conn, _params) do
    current_user_id = get_session(conn, :current_user).id
    devicegroups = Repo.all(from dg in DeviceGroup, where: dg.user_id == ^current_user_id)
    render(conn, "index.html", devicegroups: devicegroups)
  end

  def new(conn, _params) do
    changeset = DeviceGroup.changeset(%DeviceGroup{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"device_group" => device_group_params}) do
    current_user_id = get_session(conn, :current_user).id
    changeset = DeviceGroup.changeset(%DeviceGroup{employee_max_fingerprints: 1000, fingerprints_limit: 2, user_id: current_user_id}, device_group_params)

    case Repo.insert(changeset) do
      {:ok, _device_group} ->
        conn
        |> put_flash(:info, "Device group created successfully.")
        |> redirect(to: device_group_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user_id = get_session(conn, :current_user).id
    device_group = Repo.get!(DeviceGroup, id)
    if(device_group.user_id != current_user_id) do
      redirect(conn, to: device_group_path(conn, :index))
    else
      render(conn, "show.html", device_group: device_group)
    end
  end

  def edit(conn, %{"id" => id}) do
    current_user_id = get_session(conn, :current_user).id
    device_group = Repo.get!(DeviceGroup, id)
    if(device_group.user_id != current_user_id) do
      redirect(conn, to: device_group_path(conn, :index))
    else
      changeset = DeviceGroup.changeset(device_group)
      render(conn, "edit.html", device_group: device_group, changeset: changeset)
    end
  end

  def update(conn, %{"id" => id, "device_group" => device_group_params}) do
    current_user_id = get_session(conn, :current_user).id
    device_group = Repo.get!(DeviceGroup, id)
    if(device_group.user_id != current_user_id) do
      conn
      |> put_flash(:info, "Eroare la modificarea datelor! Incearca din nou!")
      |> redirect(to: device_group_path(conn, :index))
    else
      changeset = DeviceGroup.changeset(device_group, device_group_params)
      case Repo.update(changeset) do
        {:ok, device_group} ->
          conn
          |> put_flash(:info, "Device group updated successfully.")
          |> redirect(to: device_group_path(conn, :show, device_group))
        {:error, changeset} ->
          render(conn, "edit.html", device_group: device_group, changeset: changeset)
      end
    end
  end

#  def delete(conn, %{"id" => id}) do
#    device_group = Repo.get!(DeviceGroup, id)
#
#    # Here we use delete! (with a bang) because we expect
#    # it to always work (and if it does not, it will raise).
#    Repo.delete!(device_group)
#
#    conn
#    |> put_flash(:info, "Device group deleted successfully.")
#    |> redirect(to: device_group_path(conn, :index))
#  end
end
