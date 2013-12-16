
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
    if(@@current_slide + 1 <= @@slideshow.length - 1)
      @@current_slide += 1
    else
      reset_slides
    end
  end

  def reset_slides
    @@current_slide = 0
    @@slideshow = ["/common/home"]

    flow = FlowOrder.find(:all, :conditions => ["#{$audience} = TRUE AND DATE(COALESCE(start_date, NOW())) " +
                                                    "<= DATE(NOW()) AND DATE(COALESCE(end_date, NOW())) >= DATE(NOW())"], :order => $order )

    flow.each do |item|

      case item.order_group
        when "facility attendance"

          @@slideshow << "/hospital_director/facility?duration=#{item.duration.to_f}"

        when "trends"

          @@slideshow << "/common/trends?duration=#{item.duration.to_f}"

        when "area attendance"

          @@slideshow << "/common/area_attendance?duration=#{item.duration.to_f}"

        when "facility services"

          @@slideshow << "/common/facility_services?duration=#{item.duration.to_f}"

        when "facility indicators"

          @@slideshow << "/common/facility_indicators?duration=#{item.duration.to_f}"

        when "catchment areas"

          @@slideshow << "/common/catchment_areas?duration=#{item.duration.to_f}"

        when "advertisement"

          @@slideshow << "/common/advert/#{item.src_id rescue ""}?duration=#{item.duration.to_f}"

        when "announcement"

          @@slideshow << "/common/announcements?duration=#{item.duration.to_f}"

        when "educational messages"

          @@slideshow << "/common/general_message/#{item.src_id rescue ""}?duration=#{item.duration.to_f}"

        when "public health messages"

          @@slideshow << "/common/general_message/#{item.src_id rescue ""}?duration=#{item.duration.to_f}"

        when "notice board"

          @@slideshow << "/common/notice_board?duration=#{item.duration.to_f}"

        when "admission figures"

          @@slideshow << "/common/admissions?duration=#{item.duration.to_f}"


        when "adt overview"

          @@slideshow << "/common/adt_graphs?duration=#{item.duration.to_f}"

        when "dde syncs"

          @@slideshow << "/common/dde_syncs?duration=#{item.duration.to_f}"
      end

    end

  end

end