require "pry"

require "sinatra"
require "sinatra/content_for"
require "tilt/erubis"

require_relative "sequel_persistence"

configure do
  set :erb, escape_html: true
  set :port, 8787
end

configure(:development) do
  enable :sessions
  require "sinatra/reloader"
  also_reload "sequel_persistence.rb"
end

before do
  @storage = SequelPersistence.new(logger)
end

get "/" do
  redirect "/population_form"
end

get "/population_form" do
  @metro_query = @storage.all_populatations

  erb :query_results, layout: :layout
end

def format_range(range)
  if range.include?(' ')
    range_arr = range.split(' ')
  elsif range.include?('-')
    range_arr = range.split('-')
  else
    #range error
  end
  range_nums = range_arr.map { |str| str.gsub(/\D/, '').to_i }
end

post "/population_form" do
  if params[:custom_range] && params[:custom_range].empty? != true
    range = format_range(params[:custom_range])
    @metro_query = @storage.custom_range(range)
  elsif params.values.include?('on')
    params.delete("custom_range")
    @metro_query = @storage.custom_population_query(params)
  else
    @metro_query = @storage.all_populatations
  end
  erb :query_results, layout: :layout
end
