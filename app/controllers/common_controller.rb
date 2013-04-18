
class CommonController < ApplicationController

  def index
    @facility = "Kamuzu Central Hospital"
  end
	
	def display_announcements


    @announcements = Message.find(:all, :conditions => ["msg_type = 'announcement'
      AND start_date <= ? and end_date >= ?",DateTime.now,DateTime.now])
	
	end
	
end
