#!/usr/bin/ruby

require 'rubygems'
require 'mysql'
require "yaml"
require 'rubygems'
require 'webrick'
require "json"

class Areas < WEBrick::HTTPServlet::AbstractServlet

  def do_GET(request, response)
    status, content_type, body = print_result(request)

    response.status = status
    response['Content-Type'] = content_type
    response.body = body
  end

  def print_result(request)

    settings = YAML.load_file("cron_jobs/database.yml")

    result = []

    settings.each_key{|key|

      host = settings[key]["host"] || "localhost"

      user = settings[key]["username"]

      pass = settings[key]["password"]

      db = settings[key]["database"]

      con = Mysql.connect(host, user, pass, db)

      rs = con.query("Select county_district, count(distinct person_id) from person_address where voided =0
                    AND county_district IS NOT NULL group by county_district;")



      (0..(rs.num_rows - 1)).each do |i|

        row = rs.fetch_row

        result << {"location" => row[0], "population"=> row[1]}

      end


    }


    return 200, "text/html", result.to_json
  end

end

if $0 == __FILE__ then
  server = WEBrick::HTTPServer.new(:Port => 8003)
  server.mount "/area", Areas
  trap "INT" do server.shutdown end
  server.start
end