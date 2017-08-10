defmodule AdventOfCode.GetInput do
  @base_url 'http://adventofcode.com'

  def for_day(year, day) do
    url = '#{@base_url}/#{year}/day/#{day}/input'
    cookies = {'Cookie', 'session=#{Application.fetch_env!(:advent_of_code, :session_key)}'}
    {:ok, {_, _, body}} = :httpc.request(:get, {url, [cookies]}, [], [])
    String.trim(to_string body)
  end
end