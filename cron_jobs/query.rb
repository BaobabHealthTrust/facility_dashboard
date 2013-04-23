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


=end

    settings = YAML.load_file("database.yml")[ARGV[0]] rescue {}

    host = settings["host"] || "localhost"

    user = settings["username"]

    pass = settings["password"]

    db = settings["database"]

    con = Mysql.connect(host, user, pass, db)

    rs = con.query("SELECT DISTINCT location_id, COUNT(*) number_of_patients, " +
        "DATE(obs_datetime) date_of_encounter, (SELECT name FROM location " +
        "WHERE location.location_id = obs.location_id) location_name FROM obs " +
        "GROUP BY location_id, DATE(obs_datetime);")

    result = {
      "locations" => []
    }

    (0..(rs.num_rows - 1)).each do |i|

      row = rs.fetch_row

      result["locations"] << {
        "location name" => row[3],
        "date" => row[2],
        "number of patients" => row[1],
        "location id" => row[0]
      }

    end

    return 200, "text/html", result.to_json
  end


  def get_encounters

    settings = YAML.load_file("database.yml")[ARGV[0]] rescue {}

    host = settings["host"] || "localhost"

    user = settings["username"]

    pass = settings["password"]

    db = settings["database"]

    con = Mysql.connect(host, user, pass, db)

    counts = []

    results = con.query( "SELECT count(*) indicator_value, DATE(encounter_datetime) indicator_date," +
                             "(SELECT name FROM encounter_type WHERE encounter_type_id = encounter_type)" +
                             "indicator_type FROM encounter GROUP BY indicator_type, indicator_date;")

    (0..(results.num_rows -1)).each do |i|

      row = results.fetch_row

      counts << {
          "date" => row[1],
          "indicator_value" => row[0],
          "indicator_type" => row[2]
      }

    end

    return 200, "text/html", counts.to_json

  end

end

if $0 == __FILE__ then
  server = WEBrick::HTTPServer.new(:Port => 8000)
  server.mount "/stats", Stats
  trap "INT" do server.shutdown end
  server.start
end