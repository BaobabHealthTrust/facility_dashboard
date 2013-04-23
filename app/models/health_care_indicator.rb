class HealthCareIndicator < ActiveRecord::Base

  set_primary_key :indicator_id

  def update_values

    results = JSON.parse(RestClient.get("http://0.0.0.0:8000/encounters"))

    results.each do |indicator|

      health_indicator = HealthCareIndicator .new
      health_indicator.indicator_type = indicator["indicator_type"]
      health_indicator.indicator_value = indicator["indicator_value"]
      health_indicator.indicator_date = indicator["date"]
      health_indicator.save

    end


  end

end