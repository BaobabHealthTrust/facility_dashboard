class CreateFacilityThresholds < ActiveRecord::Migration
  def self.up
    create_table :facility_thresholds, :primary_key => :threshold_id do |t|

      t.integer :threshold_id
      t.string :facility
      t.integer :lower_limit, :default => 20
      t.integer :average, :default => 40
      t.integer :upper_limit, :default => 60
      t.timestamps
    end
  end

  def self.down
    drop_table :facility_thresholds
  end
end
