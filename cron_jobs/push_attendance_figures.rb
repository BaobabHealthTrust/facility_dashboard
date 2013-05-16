#!/usr/bin/ruby

require 'rubygems'
require 'mysql'
require "yaml"
require 'rest-client'
require "json"


def collect

  settings = YAML.load_file("cron_jobs/database.yml")

  host = settings["database"]["host"] || "localhost"

  user = settings["database"]["username"]

  pass = settings["database"]["password"]

  db = settings["database"]["database"]




  con = Mysql.connect(host, user, pass, db)

  result = {
      "att_fig_locations" => [], "health_indicator" => []
  }


  attendance_figures = con.query("SELECT DISTINCT location_id, COUNT(distinct person_id) number_of_patients,
                        DATE(obs_datetime) date_of_encounter, (SELECT name FROM location
                        WHERE location.location_id = obs.location_id) location_name FROM obs WHERE voided = 0 AND
                        DATE(obs_datetime) = current_date GROUP BY location_id, DATE(obs_datetime);")
=begin
  indicators = con.query("SELECT count(*) indicator_value, DATE(encounter_datetime) indicator_date," +
                             "(SELECT name FROM encounter_type WHERE encounter_type_id = encounter_type)" +
                             "indicator_type FROM encounter WHERE voided = 0 AND "+
                             "DATE(encounter_datetime) IN (current_date,subdate(current_date, 1))" +
                             "GROUP BY indicator_type, DATE(encounter_datetime);")
=end
  (0..(attendance_figures .num_rows - 1)).each do |i|

    row = attendance_figures.fetch_row

    result["att_fig_locations"] << {
        "location name" => row[3],
        "date" => row[2],
        "number of patients" => row[1],
        "location id" => row[0],
        "facility" => settings["database"]["facility"]
    }

  end
=begin
  (0..(indicators.num_rows - 1)).each do |i|

    row = indicators.fetch_row

    result["health_indicator"] << {
        "date" => row[1],
        "indicator_value" => row[0],
        "indicator_type" => row[2],
        "facility" => settings["database"]["facility"]
    }

  end
=end
  push(result)

end


def push(data_collection)

  settings = YAML.load_file("cron_jobs/database.yml")

  user = settings["dashboard"]["user"]

  password = settings["dashboard"]["password"]

  ip_address = settings["dashboard"]["dashboard_ip"]

  port = settings["dashboard"]["port"]

  url = "http://#{user}:#{password}@#{ip_address}:#{port}/consumer/updates"

  response = RestClient.post(url, data_collection)



  # RestClient.send "http://admin:admin@localhost:8003/updates", :posted => "hie"

  #post = RestClient.post "http://admin:admin@localhost:8003/updates", :posted => "hie"

end


collect

