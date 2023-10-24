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

get '/convert/:from/:to' do
  from_currency = params['from']
  to_currency = params['to']

  # Use exchangerate.host API to get exchange rates
  exchange_rates_url = "https://api.apilayer.com/exchangerates/#{from_currency}/#{to_currency}"
  data = JSON.parse(open(exchange_rates_url).read)

  # Extract the exchange rate
  exchange_rate = data['rates'][to_currency]

  # Render a view template to show the conversion
  erb :conversion, locals: { from_currency: from_currency, to_currency: to_currency, exchange_rate: exchange_rate }
end
