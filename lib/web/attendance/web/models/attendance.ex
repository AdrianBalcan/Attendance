defmodule Attendance.Attendance do
  use Attendance.Web, :model

  schema "attendances" do
    field :employeeID, :integer
    field :f_id, :integer
    field :device_hw, :string
    field :devicegroup_id, :integer
    field :status, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:employeeID, :status, :f_id, :device_hw, :devicegroup_id, :inserted_at])
    |> validate_required([:employeeID])
  end
end
