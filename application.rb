require 'rubygems'
require 'sinatra'

load 'resources/week.rb'
load 'resources/slots.rb'

get '/' do
  redirect '/week'
end
