defmodule Attendance.CompanyTest do
  use Attendance.ModelCase

  alias Attendance.Company

  @valid_attrs %{adresa: "some content", cui: "some content", judet: "some content", localitate: "some content", name: "some content", nrc: "some content", telefon: 42, user: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Company.changeset(%Company{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Company.changeset(%Company{}, @invalid_attrs)
    refute changeset.valid?
  end
end
