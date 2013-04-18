class CreateLocationTagMaps < ActiveRecord::Migration
  def self.up
    create_table :location_tag_maps, :id => false do |t|
      t.integer :location_id
      t.integer :location_tag_id
    end
  end

  def self.down
    drop_table :location_tag_maps
  end
end