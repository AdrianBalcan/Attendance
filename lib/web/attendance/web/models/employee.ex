defmodule Attendance.Employee do
  use Attendance.Web, :model

  schema "employees" do
    field :firstname, :string
    field :lastname, :string
    field :job, :string
    field :team, :string
    field :dob, Ecto.Date
    field :active, :boolean, default: false
    field :user_id, :integer

    belongs_to :companies, Attendance.Company

    timestamps()
  end
  
  @required_fields ~w(firstname lastname job team dob)
  @optional_fields ~w(user_id active)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:firstname, :lastname, :companies_id, :job, :team, :dob, :active])
    |> validate_required([:firstname, :lastname, :job, :team, :dob, :active])
  end
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
