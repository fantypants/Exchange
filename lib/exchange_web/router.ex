defmodule ExchangeWeb.Router do
  use ExchangeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", ExchangeWeb do
    pipe_through :api
  end
end
