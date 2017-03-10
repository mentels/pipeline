defmodule Pipeline do
  @moduledoc """
  Documentation for Pipeline.
  """

  @type strategy :: :eager | :lazy | :with_stages | :with_flow

  @doc """
  Counts words in the priv/words.txt with a given strategy
  """
  @spec count_words(strategy) :: map
  defdelegate count_words(strategy), to: Pipeline.CountWords

end

