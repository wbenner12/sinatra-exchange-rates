# /app.rb

require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

# define a route
get("/") do

  # build the API url, including the API key in the query string
  api_url = "https://api.exchangerate.host/list?access_key=#{ENV.fetch("CURRENCY_KEY")}"

  # use HTTP.get to retrieve the API information
  raw_data = HTTP.get(api_url)

  # convert the raw request to a string
  raw_data_string = raw_data.to_s

  # convert the string to JSON
  parsed_data = JSON.parse(raw_data_string)

  # get the symbols from the JSON
  @symbols = parsed_data.fetch("currencies").keys

  # render a view template where I show the symbols
  erb(:homepage)
end

get("/:from_currency") do
  @from_currency = params.fetch("from_currency")

  api_url = "https://api.exchangerate.host/list?access_key=#{ENV["CURRENCY_KEY"]}"

  # use HTTP.get to retrieve the API information
  raw_data = HTTP.get(api_url)

  # convert the raw request to a string
  raw_data_string = raw_data.to_s

  # convert the string to JSON
  parsed_data = JSON.parse(raw_data_string)

  # get the symbols from the JSON
  @symbols = parsed_data.fetch("currencies").keys

  # render a view template where I show the symbols
  erb(:middlepage)
end


get("/:from_currency/:to_currency") do
  @from_currency = params.fetch("from_currency")
  @to_currency = params.fetch("to_currency")

  # Use exchangerate.host API to get exchange rates
  api_url = "https://api.exchangerate.host/convert?access_key=#{ENV["CURRENCY_KEY"]}&from=#{@from_currency}&to=#{@to_currency}&amount=1"

  raw_data = HTTP.get(api_url)
  raw_data_string = raw_data.to_s
  parsed_data = JSON.parse(raw_data_string)
  @exchange_rate = parsed_data.fetch("result")


  # Render a view template to show the conversion
  erb(:conversion)
end
