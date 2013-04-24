class AttendanceFigure < ActiveRecord::Base

  set_primary_key :attendance_figure_id
  require "rest-client"

  def update_values

    temp_object = JSON.parse(RestClient.get("http://0.0.0.0:8000/stats"))

    temp_object["locations"].each do |location|

      attendance_figure = AttendanceFigure.new
      attendance_figure.attendance_figure = location["number of patients"]
      attendance_figure.attendance_figure_day = location["date"]
      attendance_figure.location_created = location["location name"]
      attendance_figure.save

    end

  end


end