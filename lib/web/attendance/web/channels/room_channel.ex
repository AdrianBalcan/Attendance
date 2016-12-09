defmodule Attendance.RoomChannel do
  use Phoenix.Channel
  require Logger

  def join(_room, _message, socket) do
    {:ok, socket}
  end

  def handle_in(_room, message, socket) do
     IO.puts(message["id"])
     cond do
       message == "keep_alive" ->
         {:reply, :ok, socket}
       String.match?(message, ~r/.*identify-ok.*/) ->
         Attendance.Repo.insert %Attendance.Attendance{employeeID: 2}
         {:reply, :ok, socket}
       true ->
         {:noreply, socket}
     end
  end   

  def terminate(reason, _socket) do
    Logger.debug"> leave #{inspect reason}"
    :ok
  end

  def join("rooms:*", _message, socket) do
    {:ok, socket}
  end
#  def join(_room, _params, _socket) do
#    {:error, %{reason: "you can only join the lobby"}}
#  end
end
