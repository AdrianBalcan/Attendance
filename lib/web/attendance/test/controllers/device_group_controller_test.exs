defmodule Attendance.DeviceGroupControllerTest do
  use Attendance.ConnCase

  alias Attendance.DeviceGroup
  @valid_attrs %{employee_max_fingerprints: 42, fingerprints_limit: 42, name: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, device_group_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing devicegroups"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, device_group_path(conn, :new)
    assert html_response(conn, 200) =~ "New device group"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, device_group_path(conn, :create), device_group: @valid_attrs
    assert redirected_to(conn) == device_group_path(conn, :index)
    assert Repo.get_by(DeviceGroup, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, device_group_path(conn, :create), device_group: @invalid_attrs
    assert html_response(conn, 200) =~ "New device group"
  end

  test "shows chosen resource", %{conn: conn} do
    device_group = Repo.insert! %DeviceGroup{}
    conn = get conn, device_group_path(conn, :show, device_group)
    assert html_response(conn, 200) =~ "Show device group"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, device_group_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    device_group = Repo.insert! %DeviceGroup{}
    conn = get conn, device_group_path(conn, :edit, device_group)
    assert html_response(conn, 200) =~ "Edit device group"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    device_group = Repo.insert! %DeviceGroup{}
    conn = put conn, device_group_path(conn, :update, device_group), device_group: @valid_attrs
    assert redirected_to(conn) == device_group_path(conn, :show, device_group)
    assert Repo.get_by(DeviceGroup, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    device_group = Repo.insert! %DeviceGroup{}
    conn = put conn, device_group_path(conn, :update, device_group), device_group: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit device group"
  end

  test "deletes chosen resource", %{conn: conn} do
    device_group = Repo.insert! %DeviceGroup{}
    conn = delete conn, device_group_path(conn, :delete, device_group)
    assert redirected_to(conn) == device_group_path(conn, :index)
    refute Repo.get(DeviceGroup, device_group.id)
  end
end
