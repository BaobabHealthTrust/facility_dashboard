require "rest-client"

def updater

  temp_object = JSON.parse(RestClient.get("http://0.0.0.0:8002/updates")) rescue raise("Start the immediate updates servelet (ruby cron_jobs/immediate_updates.rb)")

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

updater