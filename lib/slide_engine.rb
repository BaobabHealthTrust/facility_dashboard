
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
    
    @@slideshow = ["/", "/common/announcements", "/common/advert/1", "/common/advert/2",
      "/common/advert/3", "/common/advert/4", "/common/advert/5", "/facility"]

    @@slideshow = @@slideshow.shuffle
  end

end