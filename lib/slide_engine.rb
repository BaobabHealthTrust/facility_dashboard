
class SlideEngine

  @@current_slide = 0
  @@slideshow = []

  def initialize
  end

  def self.current_slide
    @@current_slide
  end

  def self.slide_show
    @@slideshow
  end

  def self.move_to_next_slide
    if(@@current_slide + 1 <= @@slideshow.length)
      @@current_slide += 1
    else
      self.reset_slides
    end
  end

  def self.reset_slides
    @@current_slide = 0

    @adverts = Message.find(:all, :select => ["msg_id, msg_id * RAND() AS "+
          "random_no, msg_type, heading, msg_text, start_date, end_date, duration, content_path, media_bg_color"],
      :order => "random_no", 
      :conditions => ["msg_type = 'advertisement' AND start_date <= ? and end_date >= ?",
        DateTime.now, DateTime.now])

    @announcements = Message.find(:all, :select => ["msg_id, msg_id * RAND() AS "+
          "random_no, msg_type, heading, msg_text, start_date, end_date, duration, content_path, media_bg_color"],
      :order => "random_no", 
      :conditions => ["msg_type = 'announcement' AND start_date <= ? and end_date >= ?",
        DateTime.now, DateTime.now])

    @educational_messages = Message.find(:all, :select => ["msg_id, msg_type, msg_group, heading, msg_text, start_date, end_date, " +
          "duration, media_height, media_width, content_path, media_bg_color"],
      :order => "sort_position",
      :conditions => ["msg_type = 'general message' AND msg_group = 'education' " +
          "AND start_date <= ? and end_date >= ?",DateTime.now, DateTime.now ])

    @public_health_messages = Message.find(:all, :select => ["msg_id, msg_type, msg_group, heading, msg_text, start_date, end_date, " +
          "duration, media_height, media_width, content_path, media_bg_color"],
      :order => "sort_position",
      :conditions => ["msg_type = 'general message' AND msg_group = 'public health' " +
          "AND start_date <= ? and end_date >= ?",DateTime.now, DateTime.now ])

    @adverts.each do |ad|
      
      @@slideshow << "/common/advert/#{ad.msg_id}"

    end

    @announcements.each do |ad|

      @@slideshow << "/common/announcements/#{ad.msg_id}"

    end

    @educational_messages.each do |ad|

      @@slideshow << "/common/general_message/#{ad.msg_id}"

    end

    @public_health_messages.each do |ad|

      @@slideshow << "/common/general_message/#{ad.msg_id}"

    end

    @@slideshow << "/common/home"

    @@slideshow << "/hospital_director/facility"

    @@slideshow << "/common/services"

    @@slideshow << "/common/trends"

    @@slideshow << "/common/facility_attendance"

    # @@slideshow = ["/common/home", "/common/announcements", "/common/advert/1", "/common/advert/2",
    #  "/common/advert/3", "/common/advert/4", "/common/advert/5", "/common/advert/7", "/facility"]

    @@slideshow = @@slideshow.shuffle
  end

end