class Message < ActiveRecord::Base

 set_primary_key :msg_id
 belongs_to :creator, :class_name => "user", :foreign_key => :creator

 validates_presence_of :msg_type, :msg_text, :creator, :created_at, :start_date, :end_date

end