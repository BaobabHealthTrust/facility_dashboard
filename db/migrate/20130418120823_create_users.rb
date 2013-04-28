class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users, :primary_key => :user_id do |t|
      t.integer :user_id
      t.string :username
      t.string :user_role
      t.string :password
      t.string :salt
      t.integer :voided
      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end