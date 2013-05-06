require "rest-client"

def updater

  temp_object = JSON.parse(RestClient.get("http://0.0.0.0:8002/updates")) rescue raise("Start the immediate updates servelet (ruby cron_jobs/immediate_updates.rb)")

  facilities = []

  temp_object["att_fig_locations"].each do |att_figures|


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

  temp_object["health_indicator"].each do |indicator|

    health_indicator = HealthCareIndicator.find(:last,
                            :conditions =>  ["indicator_type =? AND indicator_date =? AND facility =?",
                             indicator["indicator_type"],indicator["date"], indicator["facility"] ] )

    if health_indicator.blank?
      health_indicator = HealthCareIndicator.new
    end

    health_indicator.indicator_type = indicator["indicator_type"]
    health_indicator.indicator_value = indicator["indicator_value"]
    health_indicator.indicator_date = indicator["date"]
    health_indicator.facility = indicator["facility"] rescue "Unknown"
    health_indicator.save
    facilities << health_indicator.facility
  end


  facilities.each do |facility|

    new_threshold = FacilityThreshold.find_all_by_facility(facility)

    if new_threshold.nil?

      new_threshold = FacilityThreshold.new()

    end

    new_threshold.facility = facility


  end


end

updater