defmodule  Pipeline.WithFlow do
  @textfile Application.get_env(:pipeline, :file)

  def count_words() do
    @textfile
    |> File.stream!()
    |> Flow.from_enumerable()
    |> Flow.flat_map(&String.split &1)
    |> Flow.partition()
    |> Flow.reduce(fn -> %{} end, fn word, map ->
      Map.update(map, word, 1, &(&1 + 1)) end)
    |> Enum.to_list()
    |> Enum.into(%{})
  end

end
