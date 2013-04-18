class Location < ActiveRecord::Base

  set_primary_key :location_id

  has_many :catchment_areas

end