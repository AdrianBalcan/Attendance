defmodule Attendance.DeviceChannel do
  use Attendance.Web, :channel


  def join(_room, _message, socket) do
    {:ok, socket}
  end

  def handle_in(_room, message, socket) do
     message = Poison.decode!(message)
     cond do
       message["type"] == "devicegroup" ->
         hw = message["hw"]
         query = Repo.all(from d in Attendance.Device, select: d.devicegroup_id, where: d.hw == ^hw)
         result =
           case length(query) do
             0 -> [0] 
             _ -> query
           end 
         {:reply, {:ok, %{type: message["type"], result: result}}, socket}
       message["type"] == "statusSync" ->
         employeesStatus = Repo.all(from a in Attendance.Attendance,
           right_join: e in Attendance.Employee, on: e.id == a.employeeID,
           select: %{employeeID: a.employeeID, status: a.status, inserted_at: a.inserted_at},
           distinct: e.id, order_by: [desc: :id])
         {:reply, {:ok, %{type: message["type"], result: employeesStatus}}, socket}
       message["type"] == "keep_alive" ->
         {:reply, :error, socket}
       message["type"] == "enroll-ok" ->
         changeset = Attendance.Fingerprint.changeset(%Attendance.Fingerprint{}, %{"employeeID" => message["employeeID"], "template" => message["template"], "f_id" => message["f_id"]})
         case Attendance.Repo.insert(changeset) do
           {:ok, _changeset} ->
             {:reply, :ok, socket}
           {:error, _changeset} ->
             {:reply, {:ok, %{type: message["type"], result: "error"}}, socket}
           end

       message["type"] == "identify-ok" ->
          status =
            case Repo.all(from a in Attendance.Attendance, select: a.status, where: a.employeeID == ^message["employeeID"], limit: 1, order_by: [desc: a.id]) do
              ["OUT"] -> "IN"
              ["IN"]  -> "OUT"
              _       -> "IN"
            end
         changeset = Attendance.Attendance.changeset(%Attendance.Attendance{}, %{"employeeID" => message["employeeID"], "f_id" => message["f_id"], "device_hw" => message["device_hw"], "devicegroup_id" => message["devicegroup_id"], "status" => status, "inserted_at" => message["timestamp"]})
         case Attendance.Repo.insert(changeset) do
           {:ok, _changeset} ->
             {:reply, {:ok, %{type: message["type"], employeeID: message["employeeID"], result: status}}, socket}
           {:error, _changeset} ->
             {:reply, {:ok, %{type: message["type"], result: "error"}}, socket}
           end
         true ->
           {:reply, {:ok, %{response: "nothing here"}}, socket}
       end
  end   

  def terminate(_reason, _socket) do
    :ok
  end

#  def join("rooms:*", _message, socket) do
#    {:ok, socket}
#  end
#  def join(_room, _params, _socket) do
#    {:error, %{reason: "you can only join the lobby"}}
#  end
end
