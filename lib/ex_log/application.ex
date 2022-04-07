defmodule ExLog.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {ExLog.Server, ["test.log"]},
      {Task.Supervisor, name: ExLog.TaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: ExLog.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
