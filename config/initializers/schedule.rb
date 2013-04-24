require "rufus/scheduler"

scheduler = Rufus::Scheduler.start_new


scheduler.every("2m") do

  check_attendance_figures =  AttendanceFigure.first
  check_health_care = HealthCareIndicator.first
  health_care_updater = HealthCareIndicator.new
  attendance_updater = AttendanceFigure.new

  if check_attendance_figures.blank?
    attendance_updater.update_values
  end

  if check_health_care.blank?
    health_care_updater.update_values
  end

  temp_object = JSON.parse(RestClient.get("http://0.0.0.0:8002/updates"))

  temp_object["att_fig_locations"].each do |att_figures|


    attendance_figure = AttendanceFigure.find(:last,
                          :conditions =>["attendance_figure_day = ?",att_figures["date"]]  )

    if attendance_figure.blank?
      attendance_figure = AttendanceFigure.new
    end

    attendance_figure.attendance_figure = att_figures["number of patients"]
    attendance_figure.attendance_figure_day = att_figures["date"]
    attendance_figure.location_created = att_figures["location name"]
    attendance_figure.save

  end

  temp_object["health_indicator"].each do |indicator|

    health_indicator = HealthCareIndicator.find(:last,
                        :conditions =>  ["indicator_type =? AND indicator_date =?",
                                         indicator["indicator_type"],indicator["date"]] )

    if health_indicator.blank?
      health_indicator = HealthCareIndicator.new
    end

    health_indicator.indicator_type = indicator["indicator_type"]
    health_indicator.indicator_value = indicator["indicator_value"]
    health_indicator.indicator_date = indicator["date"]
    health_indicator.save

  end

end
