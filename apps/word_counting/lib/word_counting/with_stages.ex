defmodule WordCounting.WithStages do
  @textfile Application.get_env(:word_counting, :file)
  @producers_consumers_cnt 2

  def count_words() do
    @textfile
    |> producer()
    |> producers_consumers(@producers_consumers_cnt)
    |> consumer()
    |> result(300)
  end

  def result(consumer, timeout \\ 0) do
    Process.sleep(timeout)
    Pipeline.ConsumerStage.get_result(consumer)
  end

  defp producer(file) do
    {:ok, pid} = Pipeline.ProducerStage.start_link(file)
    pid
  end

  defp producers_consumers(producer, cnt) do
    Enum.map(1..cnt, fn _ ->
      {:ok, pid} = Pipeline.ConsumerProducerStage.start_link(producer)
      pid
    end)
  end

  defp consumer(producers) do
   {:ok, pid} = Pipeline.ConsumerStage.start_link(producers)
   pid
  end

end

defmodule Pipeline.ConsumerStage do
  use GenStage

  # API

  def start_link(producers), do: GenStage.start_link(__MODULE__, producers)

  def get_result(pid), do: GenStage.call(pid, :get_result)

  # Callbacks

  def init(producers) do
    Enum.each producers, fn p ->
      :ok = GenStage.async_subscribe(self(), to: p, max_demand: 1)
    end
    {:consumer, %{}}
  end

  def handle_events(events, _from, state) do
    merge_fn = fn _k, v1, v2 -> v1+v2 end
    state =
      events
      |> Enum.reduce(state,
                     fn map, acc -> Map.merge(map, acc, merge_fn) end)
    {:noreply, [], state}
  end

  def handle_call(:get_result, _from, state) do
    {:reply, state, [], state}
  end

end

defmodule Pipeline.ProducerStage do
  use GenStage

  # API

  def start_link(file), do: GenStage.start_link(__MODULE__, file)

  # Callbacks

  def init(file), do: {:producer, stream(file)}

  def handle_demand(demand, stream) do
    events = read_lines(stream, demand) 
    {:noreply, events, stream}
  end

  # Internals

  defp stream(file), do: File.open!(file) |> IO.stream(:line)

  defp read_lines(stream, num), do: Enum.take(stream, num) 
end

defmodule Pipeline.ConsumerProducerStage do
  use GenStage

  # API

  def start_link(producer), do: GenStage.start_link(__MODULE__, producer)

  # Callbacks

  def init(producer) do
    :ok = GenStage.async_subscribe(self(), to: producer, max_demand: 1)
    {:producer_consumer, nil}
  end

  def handle_events(events, _from, state) do
    IO.puts "(#{inspect self()}) Handling events: #{inspect events}" 
    event =
      events
      |> Enum.flat_map(&String.split/1)
      |> Enum.reduce(%{},
                     fn word, map -> Map.update(map, word, 1, & &1 +1) end)
    {:noreply, [event], state}
  end

end


