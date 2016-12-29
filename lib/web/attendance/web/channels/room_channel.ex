defmodule Attendance.RoomChannel do
  use Phoenix.Channel

  import Ecto.Query
  alias Attendance.Repo

  def join(_room, _message, socket) do
    {:ok, socket}
  end

  def handle_in(_room, message, socket) do
     message = Poison.decode!(message)
     cond do
       message["type"] == "devicegroup" ->
         hw = message["hw"]
         result = Repo.all(from d in Attendance.Device, select: d.devicegroup_id, where: d.hw == ^hw)
         {:reply, {:ok, %{type: message["type"], result: result}}, socket}
       message["type"] == "keep_alive" ->
         {:reply, :error, socket}
       message["type"] == "identify-ok" ->
         Attendance.Repo.insert %Attendance.Attendance{employeeID: message["id"]}
         {:reply, :ok, socket}
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
