defmodule Mix.Tasks.PopularPackages do
  use Mix.Task
  alias LocalHexdocs.Hexpm

  @shortdoc "Rebuild popular_packages.txt"

  @moduledoc """
  Fetches a list of most downloaded packages from hex.pm and stores into the
  top-level popular_packages.txt file.

  ## Usage

      mix popular_packages
  """

  @file_path File.cwd!() <> "/popular_packages.txt"
  @page_count 11

  def run([]) do
    Mix.shell().info("Fetching #{@page_count} pages of packages...")

    names = build_popular_list()
    count = length(names)

    header = """
    # The #{count} most popular packages on hex.pm, queried #{Date.utc_today() |> Date.to_string()}
    # Generated using:
    #     mix popular_packages
    """

    File.write!(@file_path, header <> Enum.join(names, "\n"))
    Mix.shell().info("Wrote #{count} package names to #{@file_path}")
  end

  defp build_popular_list() do
    1..@page_count
    |> Enum.flat_map(&Hexpm.recent_downloads_page/1)
    |> Enum.map(& &1["name"])
  end
end
