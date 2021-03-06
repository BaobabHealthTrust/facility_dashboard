class CreateMessages < ActiveRecord::Migration
  def self.up
    create_table :messages, :primary_key => :msg_id do |t|
      t.integer :msg_id
      t.column :msg_type, "ENUM('advertisement', 'general message', 'announcement')"
      t.column :msg_group, "ENUM('education', 'public health')", :default => nil
      t.column :content_type, "ENUM('video','image', 'image slideshow')", :default => nil
      t.string :heading
      t.text :msg_text
      t.decimal :duration, :scale => 2, :precision => 64
      t.integer :media_width
      t.integer :media_height
      t.string :content_path
      t.text :media_bg_color
      t.date :start_date
      t.date :end_date
      t.integer :sort_position
      t.integer :creator
      t.timestamps
    end
  end

  def self.down
    drop_table :messages
  end
end