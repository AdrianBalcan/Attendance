defmodule Attendance.FingerprintControllerTest do
  use Attendance.ConnCase

  alias Attendance.Fingerprint
  @valid_attrs %{active: true, employeeID: 42, template: "some content"}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, fingerprint_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing fingerprints"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, fingerprint_path(conn, :new)
    assert html_response(conn, 200) =~ "New fingerprint"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, fingerprint_path(conn, :create), fingerprint: @valid_attrs
    assert redirected_to(conn) == fingerprint_path(conn, :index)
    assert Repo.get_by(Fingerprint, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, fingerprint_path(conn, :create), fingerprint: @invalid_attrs
    assert html_response(conn, 200) =~ "New fingerprint"
  end

  test "shows chosen resource", %{conn: conn} do
    fingerprint = Repo.insert! %Fingerprint{}
    conn = get conn, fingerprint_path(conn, :show, fingerprint)
    assert html_response(conn, 200) =~ "Show fingerprint"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, fingerprint_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    fingerprint = Repo.insert! %Fingerprint{}
    conn = get conn, fingerprint_path(conn, :edit, fingerprint)
    assert html_response(conn, 200) =~ "Edit fingerprint"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    fingerprint = Repo.insert! %Fingerprint{}
    conn = put conn, fingerprint_path(conn, :update, fingerprint), fingerprint: @valid_attrs
    assert redirected_to(conn) == fingerprint_path(conn, :show, fingerprint)
    assert Repo.get_by(Fingerprint, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    fingerprint = Repo.insert! %Fingerprint{}
    conn = put conn, fingerprint_path(conn, :update, fingerprint), fingerprint: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit fingerprint"
  end

  test "deletes chosen resource", %{conn: conn} do
    fingerprint = Repo.insert! %Fingerprint{}
    conn = delete conn, fingerprint_path(conn, :delete, fingerprint)
    assert redirected_to(conn) == fingerprint_path(conn, :index)
    refute Repo.get(Fingerprint, fingerprint.id)
  end
end
