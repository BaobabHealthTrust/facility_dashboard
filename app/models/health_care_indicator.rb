class HealthCareIndicator < ActiveRecord::Base

  set_primary_key :indicator_id

  def update_values

    results = JSON.parse(RestClient.get("http://0.0.0.0:8001/encounters"))  rescue raise("Start the healthcare indicator
       servelet (ruby cron_jobs/health_indicators_load.rb)")

    results.each do |indicator|

      health_indicator = HealthCareIndicator .new
      health_indicator.indicator_type = indicator["indicator_type"]
      health_indicator.indicator_value = indicator["indicator_value"]
      health_indicator.indicator_date = indicator["date"]
      health_indicator.facility = indicator["facility"].blank? ? "Unknown" : location["facility"]
      health_indicator.save

    end


  end


end
