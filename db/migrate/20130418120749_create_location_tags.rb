class CreateLocationTags < ActiveRecord::Migration
  def self.up
    create_table :location_tags, :primary_key => :location_tag_id do |t|
      t.integer :location_tag_id
      t.string :location_tag_name
      t.integer :creator
      t.timestamps
    end
  end

  def self.down
    drop_table :location_tags
  end
end