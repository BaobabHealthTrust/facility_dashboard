class CreateServices < ActiveRecord::Migration
  def self.up
    create_table :services, :primary_key => :service_id do |t|
      t.integer :service_id
      t.string :service_name
      t.integer :location_offered
      t.timestamps
    end
  end

  def self.down
    drop_table :services
  end
end