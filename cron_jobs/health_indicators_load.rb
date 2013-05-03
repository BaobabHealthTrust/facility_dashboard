#!/usr/bin/ruby

require 'rubygems'
require 'mysql'
require "yaml"
require 'rubygems'
require 'webrick'
require "json"

class Encs < WEBrick::HTTPServlet::AbstractServlet

  def do_GET(request, response)
    status, content_type, body = get_encounters(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  def get_encounters(request)

    settings = YAML.load_file("cron_jobs/database.yml")

    counts = []

    settings.each_key{|key|

      host = settings[key]["host"] || "localhost"

      user = settings[key]["username"]

      pass = settings[key]["password"]

      db = settings[key]["database"]

      con = Mysql.connect(host, user, pass, db)

      results = con.query("SELECT count(*) indicator_value, DATE(encounter_datetime) indicator_date," +
                              "(SELECT name FROM encounter_type WHERE encounter_type_id = encounter_type)" +
                              "indicator_type FROM encounter WHERE voided = 0 AND YEAR(encounter_datetime) = YEAR(current_date) GROUP BY indicator_type, DATE(encounter_datetime);")


      (0..(results.num_rows - 1)).each do |i|

        row = results.fetch_row

        counts << {
            "date" => row[1],
            "indicator_value" => row[0],
            "indicator_type" => row[2],
            "facility" => settings[key]["facility"]
        }

      end
    }


    return 200, "text/html", counts.to_json

  end

end

if $0 == __FILE__ then
  server = WEBrick::HTTPServer.new(:Port => 8001)
  server.mount "/encounters", Encs
  trap "INT" do server.shutdown end
  server.start
end