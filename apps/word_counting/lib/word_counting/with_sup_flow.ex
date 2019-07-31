defmodule WordCounting.WithSupFlows do
  #TODO: what is the process structure here
  #TODO: maybe just add it to the supervision tree so that it's easier to follow via observer?
  #TODO: why sometimes we get 2 events?
  use Flow

  @textfile Application.get_env(:word_counting, :file)

  def start_link() do
    @textfile
    |> File.stream!()
    |> Flow.from_enumerable(max_demand: 1)
    |> Flow.flat_map(&String.split &1)
    |> Flow.partition()
    |> Flow.reduce(fn -> %{} end, fn word, map ->
      Map.update(map, word, 1, &(&1 + 1)) end)
    |> Flow.into_specs(consumers(), name: :sup_flow_word_counting)
  end

  def consumers() do
    [
      {%{start: {__MODULE__.Consumer, :start_link, []}}, []}
    ]
  end

  defmodule Consumer do
    use GenStage

    def start_link() do
      GenStage.start_link(__MODULE__, name: :sup_flow_consumer)
    end

    def init(_) do
      {:consumer, %{}}
    end

    def handle_events(events, _from, state) do
      IO.puts "Got events: #{inspect events}"
      {:noreply, [], state}
    end

  end
end
