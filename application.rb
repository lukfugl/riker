require 'rubygems'
require 'sinatra'
require 'models/slot'

def load_slots(params)
  return unless params[:YYYY] =~ /^\d{4}$/
  return unless params[:MM] =~ /^\d{2}$/
  return unless params[:DD] =~ /^\d{2}$/
  day = Date.parse("#{params[:YYYY]}-#{params[:MM]}-#{params[:DD]}")

  if params[:HH]
    return unless params[:HH] =~ /^\d{2}$/
    hour = params[:HH].to_i
  else
    hour = nil
  end

  if params[:layer]
    layer = params[:layer]
  else
    layer = nil
  end

  Slot[:day => day, :hour => hour, :layer => layer]
end

get '/:YYYY/:MM/:DD/:HH/:layer' do
  pass unless slot = load_slots(params)

  content_type 'text/plain'
  slot.label
end

put '/:YYYY/:MM/:DD/:HH/:layer' do
  pass unless slot = load_slots(params)

  slot.label = request.env["rack.input"].read
  slot.save
end

post '/:YYYY/:MM/:DD/:HH/:layer' do
  pass unless slot = load_slots(params)

  slot.label = request.env["rack.input"].read
  slot.save
end

delete '/:YYYY/:MM/:DD/:HH/:layer' do
  pass unless slot = load_slots(params)

  slot.label = ""
  slot.save
end

get '/:YYYY/:MM/:DD/:HH' do
  pass unless slots = load_slots(params)

  labels = {}
  slots.each{ |slot| labels[slot.layer] = slot.label }

  content_type 'text/json'
  labels.to_json
end

get '/:YYYY/:MM/:DD/:layer' do
  pass unless slots = load_slots(params)

  labels = {}
  slots.each{ |slot| labels[slot.hour] = slot.label }

  content_type 'text/json'
  labels.to_json
end

get '/:YYYY/:MM/:DD' do
  pass unless slots = load_slots(params)

  labels = {}
  slots.each do |slot|
    labels[slot.layer] ||= {}
    labels[slot.layer][slot.hour] = slot.label
  end

  content_type 'text/json'
  labels.to_json
end
