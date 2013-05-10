#!/usr/bin/ruby

require 'rubygems'
require 'mysql'
require "yaml"
require 'rubygems'
require 'webrick'
require "json"

class Updates < WEBrick::HTTPServlet::AbstractServlet

  def do_GET(request, response)
    status, content_type, body = print_result(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  def print_result(request)



    settings = YAML.load_file("database.yml")

    result = {
        "att_fig_locations" => [], "health_indicator" => []
    }

    settings.each_key{|key|

      host = settings[key]["host"] || "localhost"

      user = settings[key]["username"]

      pass = settings[key]["password"]

      db = settings[key]["database"]

      con = Mysql.connect(host, user, pass, db)

      attendance_figures = con.query("SELECT DISTINCT location_id, COUNT(distinct person_id) number_of_patients,
                         DATE(obs_datetime) date_of_encounter, (SELECT name FROM location
                         WHERE location.location_id = obs.location_id) location_name FROM obs
                          WHERE voided = 0 AND DATE(obs_datetime) IN (current_date,subdate(current_date, 1))
                         GROUP BY location_id, DATE(obs_datetime);")

      indicators = con.query("SELECT count(*) indicator_value, DATE(encounter_datetime) indicator_date," +
                      "(SELECT name FROM encounter_type WHERE encounter_type_id = encounter_type)" +
                      "indicator_type FROM encounter WHERE voided = 0 AND "+
                      "DATE(encounter_datetime) IN (current_date,subdate(current_date, 1))" +
                      "GROUP BY indicator_type, DATE(encounter_datetime);")

      (0..(attendance_figures .num_rows - 1)).each do |i|

        row = attendance_figures.fetch_row

        result["att_fig_locations"] << {
            "location name" => row[3],
            "date" => row[2],
            "number of patients" => row[1],
            "location id" => row[0],
            "facility" => settings[key]["facility"]
        }

      end

      (0..(indicators.num_rows - 1)).each do |i|

        row = indicators.fetch_row

        result["health_indicator"] << {
            "date" => row[1],
            "indicator_value" => row[0],
            "indicator_type" => row[2],
            "facility" => settings[key]["facility"]
        }

      end


    }


    return 200, "text/html", result.to_json
  end

end

if $0 == __FILE__ then
  server = WEBrick::HTTPServer.new(:Port => 8002)
  server.mount "/updates", Updates
  trap "INT" do server.shutdown end
  server.start
end