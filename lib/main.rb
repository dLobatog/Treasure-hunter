require 'sinatra'

set :public, 'public'
set :views,  'views'

get '/' do
  erb :index
end
