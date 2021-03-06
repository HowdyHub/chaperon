defmodule Firehose.Scenario.PublishRountrip do
  use Chaperon.Scenario

  def run(session) do
    session
    |> subscribe
    |> publish_receive_loop(session.config.iterations)
  end

  def publish_receive_loop(session, 0), do: session

  def publish_receive_loop(session, iterations) do
    session
    >>> publish_roundtrip
    |> publish_receive_loop(iterations - 1)
  end

  def publish_roundtrip(session) do
    session
    |> publish
    |> ws_recv
  end

  def subscribe(session) do
    session
    |> ws_connect(session.config.channel)
    |> ws_send(json: %{last_message_sequence: 0})
  end

  def publish(session) do
    session
    |> put(session.config.channel, json: json_message())
  end

  def json_message do
    %{"hello" => "world", "time" => Chaperon.Timing.timestamp}
  end
end

defmodule Firehose.LoadTest.PublishRountrip.Local do
  alias Firehose.Scenario.PublishRountrip

  use Chaperon.LoadTest

  def default_config, do: %{
    scenario_timeout: 25_000,
    base_url: "http://localhost:7474",
    channel: "/testchannel"
  }

  def scenarios, do: [
    {PublishRountrip, %{
      iterations: 500
    }}
  ]
end

Chaperon.run_load_test(Firehose.LoadTest.PublishRountrip.Local)
