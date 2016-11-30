defmodule Attendance.DeviceTest do
  use Attendance.ModelCase

  alias Attendance.Device

  @valid_attrs %{companyID: 42, expire: %{day: 17, month: 4, year: 2010}, hw: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Device.changeset(%Device{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Device.changeset(%Device{}, @invalid_attrs)
    refute changeset.valid?
  end
end
