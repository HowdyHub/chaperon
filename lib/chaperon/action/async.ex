defmodule Chaperon.Action.Async do
  defstruct module: nil,
            function: nil,
            args: []

  @type t :: %Chaperon.Action.Async{
    module: atom,
    function: atom,
    args: [any]
  }
end

defimpl Chaperon.Actionable, for: Chaperon.Action.Async do
  require Logger
  alias Chaperon.Session
  import Chaperon.Util, only: [timestamp: 0]

  def run(action = %{module: mod, function: func_name, args: args}, session) do
    Logger.debug "Async: #{func_name} #{inspect args}"
    task = action |> execute_task(session)

    session
    |> Session.add_async_task(func_name, task)
    |> Session.ok
  end

  def abort(_action, session) do
    {:ok, session}
  end

  def retry(action, session) do
    Chaperon.Action.retry(action, session)
  end

  defp execute_task(%{module: mod, function: func_name, args: args}, session) do
    Task.async fn ->
      start = timestamp
      session = apply(mod, func_name, [session | args])
      duration = timestamp - start
      session |> Session.add_metric([:duration, func_name], duration)
    end
  end
end

defimpl String.Chars, for: Chaperon.Action.Async do
  def to_string(%{module: mod, function: func_name, args: args}) do
    "Async[#{mod}.#{func_name}/#{Enum.count(args)}]"
  end
end