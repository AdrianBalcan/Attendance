defmodule Attendance.DeviceGroupTest do
  use Attendance.ModelCase

  alias Attendance.DeviceGroup

  @valid_attrs %{employee_max_fingerprints: 42, fingerprints_limit: 42, name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = DeviceGroup.changeset(%DeviceGroup{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = DeviceGroup.changeset(%DeviceGroup{}, @invalid_attrs)
    refute changeset.valid?
  end
end
