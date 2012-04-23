require 'main'
require 'rspec_helper'

set :environment, :test

describe "main controller" do
  def app
    Sinatra::Application 
  end

  it "says hello" do
    get '/'
    last_response.should be_ok
    last_response.body.should == 'Hello World'
  end
end
