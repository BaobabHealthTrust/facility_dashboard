#!/usr/bin/ruby

require 'rubygems'
require 'mysql'
require "yaml"
require 'rubygems'
require 'webrick'
require "json"

class Stats < WEBrick::HTTPServlet::AbstractServlet

  def do_GET(request, response)
    status, content_type, body = print_result(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  def print_result(request)

=begin

    settings = YAML.load_file("database.yml") rescue {}
    YAML.load(File.open(File.join(RAILS_ROOT, "config/database.yml"), "r"))['bart']

=end

    settings = YAML.load_file("cron_jobs/database.yml")

    result = {
        "locations" => []
    }

    settings.each_key{|key|

      host = settings[key]["host"] || "localhost"

      user = settings[key]["username"]

      pass = settings[key]["password"]

      db = settings[key]["database"]

      con = Mysql.connect(host, user, pass, db)

      rs = con.query("SELECT DISTINCT location_id, COUNT(distinct person_id) number_of_patients, " +
                         "DATE(obs_datetime) date_of_encounter, (SELECT name FROM location " +
                         "WHERE location.location_id = obs.location_id) location_name FROM obs " +
                         "WHERE voided = 0 AND YEAR(obs_datetime) = YEAR(current_date) GROUP BY location_id, DATE(obs_datetime);")



      (0..(rs.num_rows - 1)).each do |i|

        row = rs.fetch_row

        result["locations"] << {
            "location name" => row[3],
            "date" => row[2],
            "number of patients" => row[1],
            "location id" => row[0],
            "facility" => settings[key]["facility"]
        }

      end


    }


    return 200, "text/html", result.to_json
  end

end

if $0 == __FILE__ then
  server = WEBrick::HTTPServer.new(:Port => 8000)
  server.mount "/stats", Stats
  trap "INT" do server.shutdown end
  server.start
end