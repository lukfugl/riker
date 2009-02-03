require 'models/slot'
require 'date'
require 'prawn'
require 'prawn/layout'

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

get '/week/:date/pdf' do
  # load the dates and make sure we've redirected to the canonical date for the
  # week (sunday), except in the case of no-date-provided
  pass unless parse_date(params)

  # load the labels from the database
  load_days

  doc = Prawn::Document.new(:page_layout => :landscape) do |pdf|
    header = @sunday.strftime(@sunday.year == @saturday.year ? '%B %d' : '%B %d, %Y') +
      "—" + @saturday.strftime('%B %d, %Y')

    data = (8..20).map do |hour|
      [
        "%02d00" % hour,
        *@days.map do |day|
          slot = day[:slots].detect{ |s| s.hour == hour }
          slot ? slot.label : ''
        end
      ]
    end

    pdf.header(pdf.margin_box.top_left) do
      pdf.text header
      pdf.stroke_horizontal_rule
    end

    headers = [ '', 'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday' ]
    column_width = pdf.margin_box.width / 9
    column_widths = {}
    (0..7).each{ |i| column_widths[i] = column_width }

    pdf.pad_top(50) do
      pdf.table data,
        :position => :center,
        :headers => headers,
        :row_colors => [ 'ffffff', 'dddddd' ],
        :column_widths => column_widths,
        :align => { 0 => :right }
    end
  end

  content_type 'application/pdf'
  attachment "riker-#{@sunday}.pdf"
  doc.render
end
