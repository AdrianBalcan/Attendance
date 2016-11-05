defmodule Attendance.Fingerprint do
  use Attendance.Web, :model

  schema "fingerprints" do
    field :employeeID, :integer
    field :template, :binary
    field :active, :boolean, default: true

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:employeeID, :template, :active])
    |> validate_required([:employeeID, :template, :active])
  end
end
