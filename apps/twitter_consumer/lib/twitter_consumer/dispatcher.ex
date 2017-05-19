defmodule TwitterConsumer.Dispatcher do
  alias TwitterConsumer.Indexer
  alias ExTwitter.Model.Tweet

  @spec start_link(Keyword.t, Keyword.t) :: {:ok, pid}
  def start_link(stream_opts, disp_opts) do
    spawn_link(fn -> streamer(stream_opts, disp_opts) end)
  end

  def streamer(stream_opts, _disp_opts) do
    ExTwitter.stream_filter(stream_opts)
    |> Stream.each(&index_htags(&1))
    |> Stream.each(&index_tweet(&1))
    |> Enum.to_list
  end

  @spec index_htags(Tweet.t) :: no_return
  def index_htags(tweet) do
    for h <- tweet.entities.hashtags do
      Indexer.update_htag_to_cnt(h)
      Indexer.update_htag_to_tid(h, tweet.id)
    end
  end

  def index_tweet(tweet) do
    Indexer.update_tid_to_tweet(tweet.id, tweet.text)
  end

end
