defmodule Rumbl.InfoSys.Bing do 
  import SweetXml
  import Ecto.Query, only: [from: 2]
  alias Rumbl.InfoSys.Result

  def start_link(query, query_ref, owner, limit) do
    Task.start_link(__MODULE__, :fetch, [query, query_ref, owner, limit])
  end
  
  def fetch(query_str, query_ref, owner, _limit) do
    query_str
    |> fetch_xml()
    |> xpath(~x"//link[@rel='http://schemas.microsoft.com/ado/2007/08/dataservices/related/News']/m:inline/feed/entry/content/m:properties/d:Description/text()")
    |> send_results(query_ref, owner)
  end

  defp send_results(nil, query_ref, owner) do
    send(owner, {:results, query_ref, []})
  end
  defp send_results(answer, query_ref, owner) do
    results = [%Result{backend: user(), score: 95, text: to_string(answer)}]
    send(owner, {:results, query_ref, results})
  end
  
  def fetch_xml(query_str) do
    {:ok, {_, _, body}} = :httpc.request(:get, {build_url(query_str), [{'Authorization', 'Basic ' ++ app_id()}]}, [], [] )
    body
  end

  def build_url(query_str) do
      String.to_char_list("https://api.datamarket.azure.com/Bing/Search/v1/Composite" <> 
                          "?Sources='news'" <>
                          "&Query='#{URI.encode(query_str)}'")
  end


  def app_id(), do: Application.get_env(:rumbl, :bing)[:app_id]

  defp user() do
    Rumbl.Repo.one!(from u in Rumbl.User, where: u.username == "bing")
  end

end
