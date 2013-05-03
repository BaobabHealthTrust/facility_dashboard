require "rest-client"

def load_catchments

  results = JSON.parse(RestClient.get("0.0.0.0:8003/area")) rescue raise("Start the immediate updates servelet (ruby cron_jobs/load_catchment.rb)")

  results.each do |area|

    new_area = CatchmentArea.find_by_location(area.location) rescue nil

    if new_area.nil?
      new_area = CatchmentArea.new
    end

    new_area.population_size = area["population"]
    new_area.location = area["location"]
    new_area.save

  end

end


load_catchments