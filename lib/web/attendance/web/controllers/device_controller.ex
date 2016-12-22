defmodule Attendance.DeviceController do
  use Attendance.Web, :controller

  plug Attendance.Plug.Authenticate
  alias Attendance.DeviceGroup
  alias Attendance.Device

  def index(conn, _params) do
    current_user_id = get_session(conn, :current_user).id
    devices = Repo.all(Device)
    devices = Repo.all(from d in Attendance.Device, join: dg in DeviceGroup, on: d.devicegroup_id == dg.id, where: dg.user_id == ^current_user_id)
    render(conn, "index.html", devices: devices)
  end

  def new(conn, _params) do
    current_user_id = get_session(conn, :current_user).id
    devicegroups = Repo.all(from gd in Attendance.DeviceGroup, [select: {gd.id, gd.id}, where: gd.user_id == ^current_user_id])
    changeset = Device.changeset(%Device{})
    render(conn, "new.html", changeset: changeset, devicegroups: devicegroups)
  end

  def create(conn, %{"device" => device_params}) do
    current_user_id = get_session(conn, :current_user).id
    changeset = Device.changeset(%Device{}, device_params)

    case Repo.insert(changeset) do
      {:ok, _device} ->
        conn
        |> put_flash(:info, "Dispozitivul a fost adaugat in contul dumneavoastra.")
        |> redirect(to: device_path(conn, :index))
      {:error, changeset} ->
        devicegroups = Repo.all(from gd in Attendance.DeviceGroup, [select: {gd.id, gd.id}, where: gd.user_id == ^current_user_id])
        render(conn, "new.html", changeset: changeset, devicegroups: devicegroups)
    end
  end

  def show(conn, %{"id" => id}) do
    current_user_id = get_session(conn, :current_user).id
    [device] = Repo.all(from d in Attendance.Device, join: dg in DeviceGroup, on: d.devicegroup_id == dg.id, select: %{id: d.id, hw: d.hw, devicegroup_id: d.devicegroup_id, user_id: dg.user_id}, where: d.id == ^id)
    if(to_string(device.user_id) == to_string(current_user_id)) do
      render(conn, "show.html", device: device)
    else
      redirect(conn, to: device_path(conn, :index))
    end
  end

  def edit(conn, %{"id" => id}) do
    current_user_id = get_session(conn, :current_user).id
    [secure] = Repo.all(from d in Attendance.Device, join: dg in DeviceGroup, on: d.devicegroup_id == dg.id, select: dg.user_id, where: d.id == ^id)
    if secure != current_user_id do
      conn
      |> put_flash(:error, "Eroare la modificarea datelor! Incearca din nou!")
      |> redirect(to: employee_path(conn, :index))
    else
      devicegroups = Repo.all(from dg in Attendance.DeviceGroup, [select: {dg.id, dg.id}, where: dg.user_id == ^current_user_id])
      device = Repo.get!(Device, id)
      changeset = Device.changeset(device)
      render(conn, "edit.html", device: device, changeset: changeset, devicegroups: devicegroups)
    end
  end

  def update(conn, %{"id" => id, "device" => device_params}) do
    device = Repo.get!(Device, id)
    changeset = Device.changeset(device, device_params)

    case Repo.update(changeset) do
      {:ok, device} ->
        conn
        |> put_flash(:info, "Device updated successfully.")
        |> redirect(to: device_path(conn, :show, device))
      {:error, changeset} ->
        render(conn, "edit.html", device: device, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    device = Repo.get!(Device, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(device)

    conn
    |> put_flash(:info, "Device deleted successfully.")
    |> redirect(to: device_path(conn, :index))
  end
end
