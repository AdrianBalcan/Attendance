defmodule Attendance.User do
  use Attendance.Web, :model

  schema "users" do
    field :firstname, :string
    field :lastname, :string
    field :phone, :string
    field :email, :string, unique: true
    field :encrypted_password, :string
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true

    has_many :companies, Attendance.Company
    has_many :devicegroups, Attendance.DeviceGroup

    timestamps()
  end
  
  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(model, params \\ %{}) do
    cast(model, params, ~w(firstname lastname phone email password password_confirmation))
    #cast(model, params, [:firstname, :lastname, :email, :password, :password_confirmation])
    |> cast_assoc(:companies)
    |> cast_assoc(:devicegroups)
    |> validate_required([:firstname, :lastname, :email, :phone])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email, on: Attendance.Repo, downcase: true)
    |> validate_length(:password, min: 1)
    |> validate_length(:password_confirmation, min: 1)
    |> validate_confirmation(:password)
  end
  #def changeset(struct, params \\ %{}) do
  #  struct
  #  |> cast(params, [:firstname, :lastname, :email, :encrypted_password])
  #  |> validate_required([:firstname, :lastname, :email, :encrypted_password])
  #end
end
