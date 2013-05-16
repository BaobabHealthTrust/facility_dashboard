
class ConsumerController < ActionController::Base


  def updates

    att_figures = params["att_fig_locations"]


    unless att_figures.nil?

      attendance_figure = AttendanceFigure.find(:first,
                                                :conditions =>["attendance_figure_day = ?
                          AND facility = ? AND location_created =?",
                                                               att_figures["date"], att_figures["facility"],
                                                               att_figures["location name"] ]  )

      if attendance_figure.blank?
        attendance_figure = AttendanceFigure.new
      end

      attendance_figure.attendance_figure = att_figures["number of patients"]
      attendance_figure.attendance_figure_day = att_figures["date"]
      attendance_figure.location_created = att_figures["location name"]
      attendance_figure.facility = att_figures["facility"] rescue "Unknown"
      attendance_figure.save



    end


  end

end