defmodule ExLog.Server do
  @moduledoc """
  This is the log server.

  1. At first sight, what possible issues and/or improvements do you see

  2. Supposing the server will face high concurrency, what other improvements
     we can make to this logger implementation and why?
  """

  @behaviour GenServer

  ## API

  @doc false
  def start_link(filename) do
    GenServer.start_link(__MODULE__, filename, name: __MODULE__)
  end

  @doc false
  def child_spec(filename) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [filename]}
    }
  end

  @doc false
  def log(data) do
    GenServer.call(__MODULE__, {:log, data})
  end

  ## GenServer Callbacks

  @impl true
  def init(filename) do
    _ = File.rm(filename)
    Process.flag(:trap_exit, true)
    schedule_dump()
    {:ok, %{filename: filename, io_device: nil, data: []}, {:continue, :open_file}}
  end

  @impl true
  def handle_continue(:open_file, %{filename: filename} = state) do
    io_device = File.open!(filename, [:append])
    {:noreply, %{state | io_device: io_device}}
  end

  @impl true
  def handle_call({:log, input}, _from, %{data: data} = state) do
    {:reply, :ok, %{state | data: [input | data]}}
  end

  @impl true
  def handle_info({:EXIT, _pid, reason}, %{io_device: io_device} = state) do
    :ok = File.close(io_device)

    IO.puts("Process terminating...\n")

    {:stop, reason, state}
  end

  def handle_info(:dump, %{io_device: io_device, data: data} = state) do
    if data != [], do: IO.puts(io_device, data |> Enum.reverse() |> Enum.join("\n"))
    schedule_dump()
    {:noreply, %{state | data: []}}
  end

  defp schedule_dump, do: Process.send_after(self(), :dump, 5_000)
end
