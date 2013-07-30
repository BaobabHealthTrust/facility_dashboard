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



    settings = YAML.load_file(File.dirname(__FILE__)+"/database.yml")

    result = {
        "att_fig_locations" => [], "health_indicator" => [], "common" => 0
    }



      host = settings["registration"]["host"] || "localhost"

      user = settings["registration"]["username"]

      pass = settings["registration"]["password"]

      db = settings["registration"]["database"]

      con = Mysql.connect(host, user, pass, db)

      attendance_figures = con.query("SELECT count(person_id) number_of_patients,DATE(obs_datetime)
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


    attendance_figures = con.query("SELECT COUNT(DISTINCT patient_id) number_of_patients,
                            DATE(encounter_datetime) date_of_encounter,
                            (SELECT name FROM location WHERE location.location_id = encounter.location_id) location_name
                            FROM encounter WHERE voided = 0 AND DATE(encounter_datetime) = current_date
                            AND encounter_type = (SELECT encounter_type_id FROM encounter_type
                            WHERE name = 'RADIOLOGY EXAMINATION' LIMIT 1);")


    (0..(attendance_figures .num_rows - 1)).each do |i|

      row = attendance_figures.fetch_row
			unless row[1].nil?
				result["att_fig_locations"] << {
		        "location name" => settings["registration"]["facility"] ,
		        "date" => row[1] ,
		        "number of patients" => row[0],
		        "facility" => "Radiology"
		    }
			end


    end


    total_admission = con.query("SELECT count(*) FROM encounter WHERE DATE(encounter_datetime) = current_date AND voided = 0 AND
                                  encounter_type = (SELECT encounter_type_id FROM encounter_type WHERE name = 'ADMIT PATIENT')")

    total_discharge = con.query("SELECT count(*) FROM encounter WHERE DATE(encounter_datetime) = current_date AND voided = 0 AND
                                  encounter_type = (SELECT encounter_type_id FROM encounter_type WHERE name = 'DISCHARGE PATIENT')")

    bed_count = con.query("SELECT SUM(bed_number) FROM ward").fetch_row[0] rescue nil

    indicator = total_admission.fetch_row

    indicator2 = total_discharge.fetch_row

    result["health_indicator"] << {
       "indicator_value" => indicator[0],
       "indicator_type" => "Total Admissions",
       "facility" => settings["registration"]["facility"],
       "date" => Date.today
    }

    result["health_indicator"] << {
        "indicator_value" => indicator2[0],
        "indicator_type" => "Total Discharges",
        "facility" => settings["registration"]["facility"],
        "date" => Date.today
    }

    unless bed_count.nil?
      bed_ratio = indicator[0].to_i/bed_count.to_i rescue 0
      turn_over = indicator2[0].to_i/bed_count.to_i rescue 0
      result["health_indicator"] << {
          "indicator_value" => bed_ratio,
          "indicator_type" => "Bed Occupancy Ratio",
          "facility" => settings["registration"]["facility"],
          "date" => Date.today
      }  << {
          "indicator_value" => turn_over,
          "indicator_type" => "Bed Turn Over Rate",
          "facility" => settings["registration"]["facility"],
          "date" => Date.today
      }

    end




    admissions = con.query("SELECT count(*), value_text, DATE(obs_datetime) FROM obs WHERE DATE(obs_datetime)= current_date
                            AND concept_id = (SELECT concept_id FROM concept_name WHERE name = 'ADMIT TO WARD')
                            AND voided = 0 GROUP BY value_text ")

    (0..(admissions.num_rows - 1)).each do |i|
       indicator = admissions.fetch_row
       result["health_indicator"] << {
           "indicator_value" => indicator[0],
           "indicator_type" => "admission",
           "facility" => indicator[1],
           "date" => indicator[2]
       }
    end




    return 200, "text/html", result.to_json
  end

end

if $0 == __FILE__ then
  server = WEBrick::HTTPServer.new(:Port => 8002)
  server.mount "/updates", Updates
  trap "INT" do server.shutdown end
  server.start
end
