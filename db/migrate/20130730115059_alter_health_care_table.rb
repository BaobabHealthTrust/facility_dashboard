class AlterHealthCareTable < ActiveRecord::Migration
  def self.up

    change_table :health_care_indicators do |t|
        t.change :indicator_value ,:double
    end

  end

  def self.down
    change_table :health_care_indicators do |t|
      t.change :indicator_value ,:integer
    end
  end
end
