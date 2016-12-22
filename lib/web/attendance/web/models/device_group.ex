defmodule Attendance.DeviceGroup do
  use Attendance.Web, :model

  schema "devicegroups" do
    field :name, :string
    field :employee_max_fingerprints, :integer
    field :fingerprints_limit, :integer
    belongs_to :user, Attendance.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :employee_max_fingerprints, :fingerprints_limit])
    |> validate_required([:name, :employee_max_fingerprints, :fingerprints_limit])
  end
end
