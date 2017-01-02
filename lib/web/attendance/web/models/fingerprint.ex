defmodule Attendance.Fingerprint do
  use Attendance.Web, :model

  schema "fingerprints" do
    field :f_id, :integer
    field :employeeID, :integer
    field :template, :binary
    field :active, :boolean

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:f_id, :employeeID, :template, :active])
    |> validate_required([:f_id, :employeeID, :template])
  end
end
