require 'sinatra'

set :views, 'views/'

get '/' do
  erb :index
end
