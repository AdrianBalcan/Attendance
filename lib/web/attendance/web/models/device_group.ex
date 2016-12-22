defmodule Attendance.DeviceGroup do
  use Attendance.Web, :model

  schema "devicegroups" do
    field :name, :string
    field :employee_max_fingerprints, :integer
    field :fingerprints_limit, :integer
    belongs_to :user, Attendance.User

    timestamps()
  end

  @required_fields ~w()
  @optional_fields ~w(name user_id employee_max_fingerprints fingerprints_limit)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, @required_fields, @optional_fields)
  end
end
