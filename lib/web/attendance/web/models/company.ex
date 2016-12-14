defmodule Attendance.Company do
  use Attendance.Web, :model

  schema "companies" do
    field :name, :string
    field :cui, :string
    field :nrc, :string
    field :adresa, :string
    field :localitate, :string
    field :judet, :string
    field :telefon, :integer

    belongs_to :user, Attendance.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :cui, :nrc, :adresa, :localitate, :judet, :telefon])
    |> validate_required([:name])
  end
end
