defmodule Services.RateWorker do
  import Logger, only: [debug: 1]
  use GenServer
  alias Services.ExchangeParser
  def start_link do
    GenServer.start_link(__MODULE__, [:ok], name: __MODULE__)
  end
  def init(state) do
    send(self(), :work)
    {:ok, state}
  end
  def handle_info(:work, state) do
    # warming the caches
    {status, data} = ExchangeParser.get_xml
    ExchangeParser.insert_into_database(data)
    {:stop, :normal, state}
  end
end
