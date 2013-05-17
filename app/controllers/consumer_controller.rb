
class ConsumerController < ActionController::Base

  require "json"
  def updates

    att_figures = params["att_fig_locations"]

    unless att_figures.blank?

      att_figures.each do |att_figures|




          attendance_figure = AttendanceFigure.new


        attendance_figure.attendance_figure = att_figures["number of patients"]
        attendance_figure.attendance_figure_day = att_figures["date"]
        attendance_figure.location_created = att_figures["location name"]
        attendance_figure.facility = att_figures["facility"] rescue "Unknown"
        attendance_figure.save

      end

    end

  end

end