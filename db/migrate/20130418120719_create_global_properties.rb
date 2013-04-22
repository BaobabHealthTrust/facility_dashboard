class CreateGlobalProperties < ActiveRecord::Migration
  def self.up
    create_table :global_properties, :primary_key => :property_id do |t|
      t.integer :property_id
      t.string :property
      t.string :value
      t.timestamps
    end
  end

  def self.down
    drop_table :global_properties
  end
end