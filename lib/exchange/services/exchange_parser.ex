defmodule Services.ExchangeParser do
  import SweetXml
  alias Exchange.Models.Money
  alias Exchange.Repo

  @url "https://www.ecb.europa.eu/stats/eurofxref/eurofxref-hist-90d.xml"

def init, do: :ok
def get_response do
  :inets.start()
  with {:ok, request_id} <- :httpc.request(:get, {@url, []}, [], [{:sync, false}]) do
    :ok
  end
end
def get_xml do
  with :ok <- get_response do
    case HTTPoison.get(@url) do
    {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
      {a,b,c} = body |> Floki.parse |> Enum.drop(1) |> List.first
      data = elem(Enum.fetch!(c,2), 2) |> Enum.flat_map(fn html -> process(html) end)
      {:ok, data}
    {:ok, %HTTPoison.Response{status_code: 404}} ->
      IO.puts "Not found :("
    {:error, %HTTPoison.Error{reason: reason}} ->
      IO.inspect reason
  end
  end
end

defp process(element) do
  {parent, time, values} = element
  [{time_label, time_value}] = time
  list = Enum.map(values, fn value -> process_raw(time_value, value) end)
  list
end

defp convert_rate(rate, type) when type == true, do: String.to_float(rate)
defp convert_rate(rate, type) when type == false, do: String.to_integer(rate)/1


defp process_raw(time, element) do
  {cube_label, [{currency_label, currency}, {rate_label, rate}], not_needed} = element
  %{date: time, currency: currency, rate: convert_rate(rate, Regex.match?(~r/[.]/, rate)), inserted_at: Timex.now, updated_at: Timex.now}
end

def insert_into_database(list), do: Enum.map(list, fn row -> ExchangeWeb.MoneyController.insert_single(row) end)
def get_rates, do: Repo.all(Money) |> Enum.count


end
