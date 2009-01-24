class CreateSlots < ActiveRecord::Migration
  def self.up
    create_table :slots do |t|
      t.date :day
      t.integer :hour
      t.string :volunteer
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :slots
  end
end
