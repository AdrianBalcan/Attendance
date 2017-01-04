defmodule Attendance.Router do
  use Attendance.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Attendance do
    pipe_through :browser # Use the default browser stack

    get "/", SessionController, :new
    get "/login", SessionController, :new
    post "/login", SessionController, :create
    get "/logout", SessionController, :delete
    get "/stats", PageController, :index
    get "/registration", RegistrationController, :new
    post "/registration", RegistrationController, :create
    post "/fingerprints/cancelEnrollment", FingerprintController, :cancelEnrollment
    resources "/fingerprints", FingerprintController
    resources "/attendances", AttendanceController
    resources "/companies", CompanyController
    resources "/employees", EmployeeController
    resources "/devicegroups", DeviceGroupController
    resources "/devices", DeviceController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Attendance do
  #   pipe_through :api
  # end
end
