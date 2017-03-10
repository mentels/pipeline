defmodule Pipeline.Eager do
  @textfile Application.get_env(:pipeline, :file)
  
  def count_words() do
    File.read!(@textfile)               # read the text file 
    |> String.split("\n")               # transform the text into lines
    |> Enum.flat_map(&String.split/1)   # transform lines into words
    |> Enum.reduce(%{}, fn word, map -> 
      Map.update(map, word, 1, & &1 +1) # count the words
    end)
  end
  
end
