class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages, :primary_key => :msg_id do |t|
      t.integer :msg_id
      t.column :msg_type, "ENUM('advertisement', 'general message', 'announcement')"
      t.column :msg_group, "ENUM('education', 'public health')", :default => nil
      t.column :content_type, "ENUM('video','image', 'image slideshow')", :default => nil
      t.string :heading
      t.text :msg_text
      t.string :content_path
      t.date :start_date
      t.date :end_date
      t.integer :creator
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end