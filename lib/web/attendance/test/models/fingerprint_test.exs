defmodule Attendance.FingerprintTest do
  use Attendance.ModelCase

  alias Attendance.Fingerprint

  @valid_attrs %{active: true, employeeID: 42, template: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Fingerprint.changeset(%Fingerprint{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Fingerprint.changeset(%Fingerprint{}, @invalid_attrs)
    refute changeset.valid?
  end
end
