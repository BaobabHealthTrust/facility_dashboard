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
        "att_fig_locations" => [], "health_indicator" => [], "common" => 0
    }



      host = settings["registration"]["host"] || "localhost"

      user = settings["registration"]["username"]

      pass = settings["registration"]["password"]

      db = settings["registration"]["database"]

      con = Mysql.connect(host, user, pass, db)

      attendance_figures = con.query("SELECT count(distinct person_id) number_of_patients,DATE(obs_datetime)
        date_of_encounter, value_text as service FROM obs
        WHERE concept_id = (SELECT concept_id FROM concept_name WHERE name = 'SERVICES' LIMIT 1)
        AND voided = 0 AND DATE(obs_datetime) = current_date GROUP BY value_text, DATE(obs_datetime);")

      #people = con.query("SELECT WHERE patient_id IN (SELECT DISTINCT patient_id FROM encounter WHERE encounter_datetime = current_date)")

      (0..(attendance_figures .num_rows - 1)).each do |i|

        row = attendance_figures.fetch_row

        result["att_fig_locations"] << {
            "location name" => settings["registration"]["facility"] ,
            "date" => row[1],
            "number of patients" => row[0],
            "facility" => row[2]
        }

      end

=begin

    host = settings["radiology"]["host"] || "localhost"

    user = settings["radiology"]["username"]

    pass = settings["radiology"]["password"]

    db = settings["radiology"]["database"]

    con = Mysql.connect(host, user, pass, db)

    attendance_figures = con.query("SELECT COUNT(distinct patient_id) number_of_patients,
                         DATE(encounter_datetime) date_of_encounter, (SELECT name FROM location
                         WHERE location.location_id = encounter.location_id) location_name FROM encounter
                          WHERE voided = 0 AND DATE(encounter_datetime) = current_date;")


    (0..(attendance_figures .num_rows - 1)).each do |i|

      row = attendance_figures.fetch_row

      result["att_fig_locations"] << {
          "location name" => row[2],
          "date" => row[1] ,
          "number of patients" => row[0],
          "facility" => "Radiology"
      }

    end

=end
    return 200, "text/html", result.to_json
  end

end

if $0 == __FILE__ then
  server = WEBrick::HTTPServer.new(:Port => 8002)
  server.mount "/updates", Updates
  trap "INT" do server.shutdown end
  server.start
end