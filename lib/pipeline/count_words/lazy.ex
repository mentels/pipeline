defmodule Pipeline.Lazy do
  @textfile Application.get_env(:pipeline, :file)

  def count_words() do
    File.stream!(@textfile)             # read the file line by line
    |> Stream.flat_map(&String.split/1) # transform each line into words
    |> Enum.reduce(%{}, fn word, map ->
      Map.update(map, word, 1, & &1 +1) # count the words never computing more than one line at a time
    end)
  end

end
