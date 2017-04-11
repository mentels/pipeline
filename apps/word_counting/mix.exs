defmodule WordCounting.Mixfile do
  use Mix.Project

  def project do
    [app: :word_counting,
     version: "0.1.0",
     elixir: "~> 1.4",
     deps_path: "../../deps/",
     build_path: "../../_build",
     config_path: "../../config/config.exs",
     lockfile: "../../mix.lock",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:gen_stage, "~> 0.11"},
     {:flow, "~> 0.11"}]
  end
end
