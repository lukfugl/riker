require 'models/slot'
require 'date'

helpers do
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
end

get '/week/:YYYY-:MM-:DD' do
  pass unless days = load_week(params)

  sunday = days.first[:day]
  saturday = days.last[:day]
  sunday = sunday.strftime(sunday.year == saturday.year ? '%B %d' : '%B %d, %Y')
  saturday = saturday.strftime('%B %d, %Y')

  haml :week, :locals => {
    :sunday => sunday,
    :saturday => saturday,
    :days => days,
    :hours => (8..20)
  }
end

# it would be nice to make this an alias instead of a redirect, so they can
# bookmark it. how do we do that in sinatra?
get '/week' do
  redirect(Time.now.strftime("/week/%Y-%m-%d"))
end
