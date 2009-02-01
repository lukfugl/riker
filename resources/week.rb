require 'models/slot'
require 'date'

def load_week(params)
  return unless params[:YYYY] =~ /^\d{4}$/
  return unless params[:MM] =~ /^\d{2}$/
  return unless params[:DD] =~ /^\d{2}$/

  day = Date.parse("#{params[:YYYY]}-#{params[:MM]}-#{params[:DD]}")
  sunday = day - day.wday
  saturday = sunday + 6

  (sunday..saturday).map do |day|
    {:day => day, :slots => Slot[:day => day]}
  end
end

get '/week/:YYYY/:MM/:DD' do
  pass unless slots = load_week(params)

  sunday = slots.first[:day]
  saturday = slots.last[:day]
  sunday = sunday.strftime(sunday.year == saturday.year ? '%B %d' : '%B %d, %Y')
  saturday = saturday.strftime('%B %d, %Y')

  haml :week, :locals => {
    :sunday => sunday,
    :saturday => saturday,
    :slots => slots,
    :hours => (8..20)
  }
end
