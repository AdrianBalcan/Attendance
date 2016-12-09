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

    get "/", PageController, :index
    resources "/employees", EmployeeController
    resources "/fingerprints", FingerprintController
    resources "/attendances", AttendanceController
    resources "/devices", DeviceController
    resources "/companies", CompanyController
  end

  # Other scopes may use custom stacks.
  # scope "/api", Attendance do
  #   pipe_through :api
  # end
end
