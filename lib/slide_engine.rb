
class SlideEngine

  @@current_slide = 0
  @@slideshow = []

  def initialize
  end

  def current_slide
    @@current_slide
  end

  def slide_show
    @@slideshow
  end

  def move_to_next_slide
    if(@@current_slide + 1 <= @@slideshow.length)
      @@current_slide += 1
    else
      reset_slides
    end
  end

  def reset_slides
    @@current_slide = 0
    @@slideshow = ["/common/home"]

    flow = FlowOrder.find(:all, :conditions => ["DATE(COALESCE(start_date, NOW())) " +
          "<= DATE(NOW()) AND DATE(COALESCE(end_date, NOW())) >= DATE(NOW())"], :order => :order_id)

    flow.each do |item|
      
      case item.order_group
      when "facility attendance"
        
        @@slideshow << "/hospital_director/facility"

      when "trends"

        @@slideshow << "/common/trends"

      when "area attendance"

        @@slideshow << "/common/area_attendance"

      when "facility services"

        @@slideshow << "/common/facility_services"

      when "facility indicators"

        @@slideshow << "/common/facility_indicators"

      when "catchment areas"

        @@slideshow << "/common/catchment_areas"

      when "advertisement"

        @@slideshow << "/common/advert"

      when "announcement"

        @@slideshow << "/common/announcements"

      when "educational messages"

        @@slideshow << "/common/general_message/#{item.src_id rescue ""}"

      when "public health messages"

        @@slideshow << "/common/general_message/#{item.src_id rescue ""}"

      end

    end

  end

end