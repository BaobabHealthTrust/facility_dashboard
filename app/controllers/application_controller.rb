# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  before_filter :set_location

  $audience = "consumer"
  $order = "consumer_order_id"

  def next_path

    $slide = SlideEngine.new if $slide.nil?

    if !$current_slide.nil? && ($current_slide + 1 == $slide.slide_show.length)
      $slide = SlideEngine.new
    end

    $slide.move_to_next_slide

    $current_slide = $slide.current_slide

    redirect_to $slide.slide_show[$current_slide]
  end

  protected

  def set_location
    @facility = "Kamuzu Central Hospital"
  end

  def cycle(c1, c2, p)
    return c1 if p%2 > 0
    return c2
  end

  def check_login

    if $current_user.nil?

      $return_path = request.path
      redirect_to :controller => "edits", :action =>  "login"

    end

  end

end
