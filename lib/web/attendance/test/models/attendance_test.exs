defmodule Attendance.AttendanceTest do
  use Attendance.ModelCase

  alias Attendance.Attendance

  @valid_attrs %{employeeID: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Attendance.changeset(%Attendance{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Attendance.changeset(%Attendance{}, @invalid_attrs)
    refute changeset.valid?
  end
end
