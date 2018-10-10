defmodule ExchangeWeb.Router do
  use ExchangeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/rates", ExchangeWeb do
    pipe_through :api
    resources "/monies", MoneyController, except: [:new, :edit]
    get "/:type", MoneyController, :filter
  end
end
