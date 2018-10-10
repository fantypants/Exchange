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
    IO.puts "Setting up the Server.."
    IO.puts "Initiating the XML request"
    {status, data} = ExchangeParser.get_xml
    IO.puts "Inserting gathered data into Postgres.."
    ExchangeParser.insert_into_database(data)
    IO.puts "Succesfully Finished inserting into DB"
    {:stop, :normal, state}
  end
end
