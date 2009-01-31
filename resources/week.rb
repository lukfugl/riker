require 'models/slot'

def load_slots(params)
  return unless params[:YYYY] =~ /^\d{4}$/
  return unless params[:MM] =~ /^\d{2}$/
  return unless params[:DD] =~ /^\d{2}$/

  day = Date.parse("#{params[:YYYY]}-#{params[:MM]}-#{params[:DD]}")
  sunday = day - day.wday
  saturday = sunday + 6

  (sunday..saturday).map do |day|
    [day, Slot[:day => day]]
  end
end

get '/week/:YYYY/:MM/:DD' do
  pass unless slots = load_slots(params)

  # TODO invoke week view
end
