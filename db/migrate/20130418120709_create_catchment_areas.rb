class CreateCatchmentAreas < ActiveRecord::Migration
  def self.up
    create_table :catchment_areas, :primary_key => :catchment_area_id do |t|
      t.integer :catchment_area_id
      t.integer :population_size
      t.integer :location_id
      t.timestamps
    end
  end

  def self.down
    drop_table :catchment_areas
  end
end