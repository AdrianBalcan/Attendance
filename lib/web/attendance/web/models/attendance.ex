defmodule Attendance.Attendance do
  use Attendance.Web, :model

  schema "attendances" do
    field :employeeID, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:employeeID])
    |> validate_required([:employeeID])
  end
end
