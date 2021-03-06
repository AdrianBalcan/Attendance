defmodule Attendance.Employee do
  use Attendance.Web, :model

  schema "employees" do
    field :firstname, :string
    field :lastname, :string
    field :job, :string
    field :team, :string
    field :phone, :string
    field :dob, Ecto.Date
    field :active, :boolean, default: false

    belongs_to :companies, Attendance.Company
    belongs_to :devicegroups, Attendance.DeviceGroup

    timestamps()
  end
  
  @required_fields ~w(firstname lastname companies_id devicegroups_id job team dob)
  @optional_fields ~w(active)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:firstname, :lastname, :phone, :companies_id, :devicegroups_id, :job, :team, :dob])
    |> validate_required([:firstname, :lastname, :companies_id, :devicegroups_id, :job, :team, :dob])
  end
#  def changeset(model, params \\ %{}) do
#    model
#    |> cast(params, @required_fields, @optional_fields)
#  end
end
