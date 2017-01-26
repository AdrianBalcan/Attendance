defmodule Attendance.DayViewControllerTest do
  use Attendance.ConnCase

  alias Attendance.DayView
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, day_view_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing day views"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, day_view_path(conn, :new)
    assert html_response(conn, 200) =~ "New day view"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, day_view_path(conn, :create), day_view: @valid_attrs
    assert redirected_to(conn) == day_view_path(conn, :index)
    assert Repo.get_by(DayView, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, day_view_path(conn, :create), day_view: @invalid_attrs
    assert html_response(conn, 200) =~ "New day view"
  end

  test "shows chosen resource", %{conn: conn} do
    day_view = Repo.insert! %DayView{}
    conn = get conn, day_view_path(conn, :show, day_view)
    assert html_response(conn, 200) =~ "Show day view"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, day_view_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    day_view = Repo.insert! %DayView{}
    conn = get conn, day_view_path(conn, :edit, day_view)
    assert html_response(conn, 200) =~ "Edit day view"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    day_view = Repo.insert! %DayView{}
    conn = put conn, day_view_path(conn, :update, day_view), day_view: @valid_attrs
    assert redirected_to(conn) == day_view_path(conn, :show, day_view)
    assert Repo.get_by(DayView, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    day_view = Repo.insert! %DayView{}
    conn = put conn, day_view_path(conn, :update, day_view), day_view: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit day view"
  end

  test "deletes chosen resource", %{conn: conn} do
    day_view = Repo.insert! %DayView{}
    conn = delete conn, day_view_path(conn, :delete, day_view)
    assert redirected_to(conn) == day_view_path(conn, :index)
    refute Repo.get(DayView, day_view.id)
  end
end
