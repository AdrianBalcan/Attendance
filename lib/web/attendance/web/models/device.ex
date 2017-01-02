defmodule Attendance.Device do
  use Attendance.Web, :model

  schema "devices" do
    field :location, :string
    field :hw, :string
    belongs_to :devicegroup, Attendance.Devicegroup

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:hw, :location, :devicegroup_id])
    |> unique_constraint(:hw, on: Attendance.Repo, downcase: true)
    |> validate_required([:hw])
  end
end
