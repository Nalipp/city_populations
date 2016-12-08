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

post "/population_form" do
  if params.empty?
    @metro_query = @storage.all_populatations
  else
    @metro_query = @storage.custom_population_query(params)
  end
  erb :query_results, layout: :layout
end
