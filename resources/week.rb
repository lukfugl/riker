require 'models/slot'
require 'date'

helpers do
  def parse_date(params)
    if params[:date]
      begin
        @day = Date.parse(params[:date])
      rescue ArgumentError
        return false
      end
    else
      @day = Date.today
    end

    @sunday = @day - @day.wday
    @saturday = @sunday + 6

    return true
  end

  def load_days
    @days = (@sunday..@saturday).map do |day|
      {:day => day, :slots => Slot[:day => day]}
    end
  end
end

get '/week/:date?' do
  # load the dates and make sure we've redirected to the canonical date for the
  # week (sunday), except in the case of no-date-provided
  pass unless parse_date(params)

  unless params[:date] && @day == @sunday
    redirect('/week/%s' % @sunday)
    return
  end

  # load the labels from the database
  load_days

  # render the view; would rather set the default charset, hrm.
  content_type 'text/html', :charset => 'utf-8'
  haml :week, :locals => {
    :sunday   => @sunday,
    :saturday => @saturday,
    :days     => @days,
    :hours    => (8..20)
  }
end

# it would be nice to make this an alias instead of a redirect, so they can
# bookmark it. how do we do that in sinatra?
get '/week/?' do
  redirect(Time.now.strftime("/week/%Y-%m-%d"))
end
