defmodule Attendance.EmployeeTest do
  use Attendance.ModelCase

  alias Attendance.Employee

  @valid_attrs %{active: true, dob: %{day: 17, month: 4, year: 2010}, firstname: "some content", job: "some content", lastname: "some content", team: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Employee.changeset(%Employee{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Employee.changeset(%Employee{}, @invalid_attrs)
    refute changeset.valid?
  end
end
