class RevisedSlots < ActiveRecord::Migration
  def self.up
    rename_column :slots, :day, :old_day

    add_column :slots, :week, :date
    add_column :slots, :day, :integer
    add_column :slots, :layer, :string
    add_column :slots, :label, :string

    Slot.find(:all).each do |slot|
      slot.week = slot.old_day - slot.old_day.wday
      slot.day = slot.old_day.wday

      if slot.notes
        Slot.create(
          :week => slot.week,
          :day => slot.day,
          :hour => slot.hour,
          :layer => "notes",
          :label => slot.notes)
      end

      if slot.volunteer
        slot.layer = "volunteers"
        slot.label = slot.volunteer
        slot.save
      else
        slot.destroy
      end
    end

    remove_column :slots, :old_day
    remove_column :slots, :volunteer
    remove_column :slots, :notes
  end

  def self.down
    rename_column :slots, :day, :old_day

    add_column :slots, :day, :date
    add_column :slots, :volunteer, :string
    add_column :slots, :notes, :text

    Slot.find(:all, :conditions => "layer = 'volunteer'").each do |slot|
      slot.day = slot.week + slot.old_day
      slot.volunteer = slot.label
      slot.save
    end

    Slot.find(:all, :conditions => "day is null").each do |slot|
      slot.day = slot.week + slot.old_day
      label = "#{slot.layer}: #{slot.label}"
      other = Slot.find(:first, :conditions => [ "day=? and hour=?", slot.day, slot.hour ])
      if other
        other.notes ||= ""
        other.notes += "\n" unless other.notes.empty?
        other.notes += label
        other.save
        slot.destroy
      else
        slot.notes = label
        slot.save
      end
    end

    remove_column :slots, :week
    remove_column :slots, :old_day
    remove_column :slots, :layer
    remove_column :slots, :label
  end
end
