class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services, :primary_key => :service_id do |t|
      t.integer :service_id
      t.string :service_name
      t.string  :location_offered
      t.boolean :available
      t.boolean :voided, :default => false
      t.timestamps
    end
  end

  def self.down
    drop_table :services
  end
end