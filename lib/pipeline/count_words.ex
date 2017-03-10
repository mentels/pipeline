defmodule Pipeline.CountWords do
  def count_words(strategy) do
    name(strategy).count_words()
  end

  def name(strategy) do
    String.to_atom("#{Pipeline}.#{Macro.camelize(Atom.to_string(strategy))}")
  end
end
