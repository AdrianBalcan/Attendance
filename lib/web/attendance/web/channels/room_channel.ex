defmodule Attendance.RoomChannel do
  use Phoenix.Channel
  require Logger

  def join("rooms:lobby", _message, socket) do
    {:ok, socket}
  end

  def join(room, _params, _socket) do
    {:error, %{reason: "you can only join the lobby. #{room}"}}
  end

  def handle_in(_room, _message, socket) do
     {:reply, :ok, socket}
  end   

  def terminate(reason, _socket) do
    Logger.debug"> leave #{inspect reason}"
    :ok
  end

end
