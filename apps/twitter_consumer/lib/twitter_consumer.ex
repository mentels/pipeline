defmodule TwitterConsumer do
  @moduledoc """
  Documentation for TwitterConsumer.
  """

  def hot_topics(:last_hour) do
    TwitterConsumer.Analytics.top_tweets(:last_hour)
  end

  def hot_topics(:daily) do
    TwitterConsumer.Analytics.top_tweets(:today)
  end
end
