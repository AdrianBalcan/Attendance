defmodule Attendance.Device do
  use Attendance.Web, :model

  schema "devices" do
    field :hw, :string
    belongs_to :devicegroup, Attendance.Devicegroup

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:hw])
    |> validate_required([:hw])
  end
end
