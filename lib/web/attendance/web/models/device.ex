defmodule Attendance.Device do
  use Attendance.Web, :model

  schema "devices" do
    field :hw, :string
    field :userID, :integer
    field :expire, Ecto.Date

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:hw, :userID, :expire])
    |> validate_required([:hw, :userID, :expire])
  end
end
