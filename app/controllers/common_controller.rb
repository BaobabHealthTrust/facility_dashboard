
class CommonController < ApplicationController

  def index
    @facility = "Kamuzu Central Hospital"
  end
	
	def display_announcements


    @announcements = Message.find(:all, :conditions => ["msg_type = 'announcement'
      AND start_date <= ? and end_date >= ?",DateTime.now,DateTime.now])
	
  end

  def display_advert

    @advert = Message.find(:first, :conditions => ["msg_type = 'advertisement'
      AND start_date <= ? and end_date >= ?",DateTime.now,DateTime.now ])

  end

  def display_general_message

    @message = Message.find(:first,:conditions => ["msg_type = 'general message'
      AND start_date <= ? and end_date >= ?",DateTime.now,DateTime.now ])

  end

  def display_services

    @services = Service.find(:all, :conditions =>  ["available = ?", true])

  end

  def facility_attendance


     #@attendance =  AttendanceFigure.find_by_sql()

  end

end
