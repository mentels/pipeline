defmodule TwitterConsumer.Indexer do
  require Logger

  @spec update_htag_to_cnt(String.t) :: :ok
  def update_htag_to_cnt(htag) do
    Logger.info("Updating htag cnt for #{inspect htag}")
    :ok
  end

  @spec update_htag_to_tid(String.t, non_neg_integer) :: :ok
  def update_htag_to_tid(htag, tid) do
    Logger.info("Updating htag to tid index for
    #{inspect htag} --> #{inspect tid}")
    :ok
  end

  @spec update_tid_to_tweet(non_neg_integer, String.t) :: :ok
  def update_tid_to_tweet(tid, tweet) do
    Logger.info("Updating tid to tweet for #{inspect tid} --> #{inspect tweet}")
    :ok
  end

end
