require 'rubygems'
require 'sinatra'

load 'resources/week.rb'
load 'resources/slots.rb'

get '/about' do
  haml :about
end

get '/' do
  redirect '/week'
end
