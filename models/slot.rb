require 'active_record'

class Slot < ActiveRecord::Base
  def self.[](opts={})
    day = opts[:day]
    hour = opts[:hour]
    layer = opts[:layer]
    if day.nil?
      raise ArgumentError
    elsif hour.nil?
      if layer.nil?
        self.find_all_by_day(day)
      else
        self.find_all_by_day_and_layer(day, layer)
      end
    elsif layer.nil?
      self.find_all_by_day_and_hour(day, hour)
    else
      self.find_or_initialize_by_day_and_hour_and_layer(day, hour, layer)
    end
  end
  # Slot[:day => day] -- all slots for any layer for the day
  # Slot[:day => day, :layer => layer] -- all slots for the given layer, day
  # Slot[:day => day, :hour => hour] -- all slots for any layer for the day+hour
  # Slot[:day => day, :hour => hour, :layer => layer] -- slot for the given
  #   layer for the day+hour (initializes a new record if not already there)

  # prevent rows with blank labels from being created/saved
  before_create :prevent_blanks
  before_update :prevent_blanks

  def prevent_blanks
    return false if new_record? and label.empty?
    destroy if label.empty?
    return true
  end
end

ActiveRecord::Base.establish_connection(
  :adapter => 'sqlite3',
  :database => 'db/development.sqlite3'
)
