class CreateFlowOrder < ActiveRecord::Migration
  def self.up
    create_table :flow_order, :primary_key => :order_id do |t|
      t.integer :order_id
      t.column :order_group, "ENUM('facility attendance', 'area attendance', " +
        "'facility services', 'announcement', 'facility indicators', " +
        "'facility alert', 'educational messages', 'advertisement', 'trends', "+
        "'catchment areas', 'public health messages')", :default => nil
      t.integer :src_id, :default => nil
      t.string :src_table, :default => nil
      t.text :description, :default => nil
      t.integer :creator
      t.timestamps
    end
  end

  def self.down
    drop_table :flow_orders
  end
end
