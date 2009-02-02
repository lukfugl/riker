require 'rubygems'
require 'sinatra'
set :port, 1701

load 'resources/week.rb'
load 'resources/slots.rb'

get '/about' do
  haml :about
end

get '/' do
  redirect '/week'
end
