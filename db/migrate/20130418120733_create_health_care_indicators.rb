class CreateHealthCareIndicators < ActiveRecord::Migration
  def self.up
    create_table :health_care_indicators, :primary_key => :indicator_id do |t|
      t.integer :indicator_id
      t.string :indicator_type
      t.integer :location_id
      t.integer :indicator_value
      t.timestamps
    end
  end

  def self.down
    drop_table :health_care_indicators
  end
end