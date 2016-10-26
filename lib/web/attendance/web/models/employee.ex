defmodule Attendance.Employee do
  use Attendance.Web, :model

  schema "employees" do
    field :firstname, :string
    field :lastname, :string
    field :job, :string
    field :team, :string
    field :dob, Ecto.Date
    field :active, :boolean, default: false

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:firstname, :lastname, :job, :team, :dob, :active])
    |> validate_required([:firstname, :lastname, :job, :team, :dob, :active])
  end
end
