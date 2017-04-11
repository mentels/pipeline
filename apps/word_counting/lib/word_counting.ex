defmodule WordCounting do
  @moduledoc """
  Documentation for Pipeline.
  """

  @type strategy :: :eager | :lazy | :with_stages | :with_flow

  @doc """
  Counts words in the priv/words.txt with a given strategy

  The `strategy' can be one of the following: `:eager', `:lazy', `:with_stages'
  or `:with_flow'.
  """
  @spec run(strategy) :: map
  def run(strategy \\ :eager) do
    name(strategy).count_words()
  end

  def name(strategy) do
    String.to_atom("#{__MODULE__}.#{Macro.camelize(Atom.to_string(strategy))}")
  end

end

