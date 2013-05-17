class CreateFlowOrder < ActiveRecord::Migration
  def self.up
    create_table :flow_order do |t|
      t.integer :order_id
      t.integer :policy_order_id
      t.integer :hos_dir_order_id
      t.integer :consumer_order_id
      t.column :order_group, "ENUM('facility attendance', 'area attendance', " +
        "'facility services', 'announcement', 'facility indicators', " +
        "'facility alert', 'educational messages', 'advertisement', 'trends', "+
        "'catchment areas', 'public health messages', 'notice board')", :default => nil
      t.integer :src_id, :default => nil
      t.string :src_table, :default => nil
      t.text :description, :default => nil
      t.boolean :policy_maker, :default => true
      t.boolean :hos_dir, :default => true
      t.boolean :consumer, :default => true
      t.decimal :duration, :scale => 2, :precision => 64
      t.date :start_date
      t.date :end_date
      t.integer :creator
      t.timestamps
    end
  end

  def self.down
    drop_table :flow_orders
  end
end
