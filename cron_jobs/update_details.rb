#!/usr/bin/ruby

require 'rubygems'
require 'rest-client'
require 'yaml'

def updater(url)

  temp_object = JSON.parse(RestClient.get(url)) rescue raise("Start the immediate updates servelet (ruby cron_jobs/immediate_updates.rb)")

  facilities = []

  temp_object["att_fig_locations"].each do |att_figures|


    attendance_figure = AttendanceFigure.find(:first,
                          :conditions =>["attendance_figure_day = ?
                          AND facility = ? AND location_created =?",
                          att_figures["date"], att_figures["facility"],
                          att_figures["location name"]]  )

    if attendance_figure.blank?
      attendance_figure = AttendanceFigure.new
    end

    attendance_figure.attendance_figure = att_figures["number of patients"]
    attendance_figure.attendance_figure_day = att_figures["date"].nil? ? Date.today : att_figures["date"]
    attendance_figure.location_created = att_figures["location name"].nil? ? "Unknown" : att_figures["location name"]
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


end


def load

  urls = YAML.load_file(File.dirname(__FILE__)+"/clients.yml")

  urls.each_key do |key|

    updater(urls[key]["url"])

  end

  facilites = AttendanceFigure.find_by_sql("SELECT distinct facility from attendance_figures")

  facilites.each do |facility|

    new_threshold = FacilityThreshold.find(:first, :conditions =>  ["facility = ?", facility.facility])

    if new_threshold.nil?
      new_threshold = FacilityThreshold.new
      new_threshold.facility = facility.facility
      new_threshold.save!

    end

  end

end

load
