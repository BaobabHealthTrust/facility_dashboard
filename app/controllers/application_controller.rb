# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :set_location, :retrieve_announcements

  protected

  def set_location
    @facility = "Kamuzu Central Hospital"
  end

  def retrieve_announcements
    @facility = "Kamuzu Central Hospital"
    
    i = 0
    @news = Message.find(:all, :select => ["msg_id, msg_id * RAND() AS "+
          "random_no, msg_type, heading, msg_text, start_date, end_date"], :order => "random_no", :limit => 10,
      :conditions => ["msg_type = 'announcement' AND start_date <= ? and end_date >= ?",
        DateTime.now, DateTime.now]).collect{|n|
      i += 1;
      "<span style='color: #{cycle("#cfe7f5", "#dc9746", i)}'><b>#{n.heading}:</b> <i>" +
        "#{n.msg_text[0..100]}#{(n.msg_text.length > 100 ? "..." : "")}</i></span>"
    }.join("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ")

    @news = "No Announcements" if @news.strip.blank?

    @news

  end

  def check_login

    unless ! @current_user.blank?

      @return_path = request.headers["HTTP_REFERER"]
      redirect_to :controller => "edits", :action =>  "login"

    end

  end

  def cycle(c1, c2, p)
    return c1 if p%2 > 0
    return c2
  end

end
