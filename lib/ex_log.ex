defmodule ExLog do
  @moduledoc false

  alias ExLog.Server, as: MyLogger

  @doc false
  def run(concurrency \\ 1) when concurrency > 0 do
    for _ <- 1..concurrency do
      Task.Supervisor.async(ExLog.TaskSupervisor, fn ->
        loop()
      end)
    end
  end

  @doc false
  def stop(tasks) do
    Enum.each(tasks, fn task ->
      Task.shutdown(task)
    end)
  end

  @doc false
  def loop do
    timestamp = DateTime.utc_now() |> DateTime.to_unix()
    MyLogger.log("This is a log line, timestamp: #{timestamp}")
    :timer.sleep(10)
    loop()
  end
end
