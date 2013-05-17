class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations, :primary_key => :location_id do |t|
      t.integer :location_id
      t.string :name
      t.string :description
      t.integer :creator
      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end