defmodule LocalHexdocs.Hexpm do
  @moduledoc """
  Adapter to the hex.pm API
  """
  @base_url "https://hex.pm/api/"

  def recent_downloads_page(page_no),
    do: api_get(@base_url <> "packages?sort=recent_downloads&page=#{page_no}")

  def get_package(name),
    do: api_get(@base_url <> "packages/#{name}")

  def api_get(url) do
    {:ok, {{_, 200, _}, _, body}} =
      :httpc.request(
        :get,
        {to_charlist(url),
         [
           {~c"user-agent", to_charlist(user_agent())},
           {~c"accept", ~c"application/json"}
         ]},
        [],
        []
      )

    Jason.decode!(body)
  end

  defp user_agent do
    # FIXME: only works in mix context.
    mix_config = Mix.Project.config()
    (mix_config[:name] || Atom.to_string(mix_config[:app])) <> " " <> mix_config[:version]
  end
end
