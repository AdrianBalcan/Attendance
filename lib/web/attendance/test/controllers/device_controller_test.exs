defmodule Attendance.DeviceControllerTest do
  use Attendance.ConnCase

  alias Attendance.Device
  @valid_attrs %{hw: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, device_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing devices"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, device_path(conn, :new)
    assert html_response(conn, 200) =~ "New device"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, device_path(conn, :create), device: @valid_attrs
    assert redirected_to(conn) == device_path(conn, :index)
    assert Repo.get_by(Device, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, device_path(conn, :create), device: @invalid_attrs
    assert html_response(conn, 200) =~ "New device"
  end

  test "shows chosen resource", %{conn: conn} do
    device = Repo.insert! %Device{}
    conn = get conn, device_path(conn, :show, device)
    assert html_response(conn, 200) =~ "Show device"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, device_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    device = Repo.insert! %Device{}
    conn = get conn, device_path(conn, :edit, device)
    assert html_response(conn, 200) =~ "Edit device"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    device = Repo.insert! %Device{}
    conn = put conn, device_path(conn, :update, device), device: @valid_attrs
    assert redirected_to(conn) == device_path(conn, :show, device)
    assert Repo.get_by(Device, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    device = Repo.insert! %Device{}
    conn = put conn, device_path(conn, :update, device), device: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit device"
  end

  test "deletes chosen resource", %{conn: conn} do
    device = Repo.insert! %Device{}
    conn = delete conn, device_path(conn, :delete, device)
    assert redirected_to(conn) == device_path(conn, :index)
    refute Repo.get(Device, device.id)
  end
end
