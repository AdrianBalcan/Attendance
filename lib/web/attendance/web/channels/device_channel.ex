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
         #if(length(query) == 0) do result = [0] else result = query end
         result =
           case query do
             0 -> [0] 
             _ -> query
           end 
         {:reply, {:ok, %{type: message["type"], result: result}}, socket}
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
         changeset = Attendance.Attendance.changeset(%Attendance.Attendance{}, %{"employeeID" => message["employeeID"], "f_id" => message["f_id"], "device_hw" => message["device_hw"], "devicegroup_id" => message["devicegroup_id"]})
         IO.inspect changeset
         case Attendance.Repo.insert(changeset) do
           {:ok, _changeset} ->
             {:reply, :ok, socket}
           {:error, _changeset} ->
             {:reply, {:ok, %{type: message["type"], result: "error"}}, socket}
           end
         true ->
           {:reply, {:ok, %{response: "nothing here"}}, socket}
       end
  end   

  def terminate(reason, _socket) do
    IO.inspect reason
    :ok
  end

#  def join("rooms:*", _message, socket) do
#    {:ok, socket}
#  end
#  def join(_room, _params, _socket) do
#    {:error, %{reason: "you can only join the lobby"}}
#  end
end
