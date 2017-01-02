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
         result = Repo.all(from d in Attendance.Device, select: d.devicegroup_id, where: d.hw == ^hw)
         if(length(result) == 0) do result = [0] end
         {:reply, {:ok, %{type: message["type"], result: result}}, socket}
       message["type"] == "keep_alive" ->
         {:reply, :error, socket}
       message["type"] == "enroll-ok" ->
         changeset = Attendance.Fingerprint.changeset(%Attendance.Fingerprint{}, %{"employeeID" => message["employeeID"], "template" => message["template"], "f_id" => message["f_id"]})
         IO.inspect changeset
         case Attendance.Repo.insert(changeset) do
           {:ok, changeset} ->
             {:reply, :ok, socket}
           {:error, changeset} ->
             {:reply, {:ok, %{type: message["type"], result: "error"}}, socket}
           end
       message["type"] == "identify-ok" ->
         changeset = Attendance.Attendance.changeset(%Attendance.Attendance{}, %{"employeeID" => message["id"]})
         case Attendance.Repo.insert(changeset) do
           {:ok, changeset} ->
             {:reply, :ok, socket}
           {:error, changeset} ->
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
