class Location < ActiveRecord::Base

  set_primary_key :location_id

  has_many :catchment_areas

  validates_presence_of :name , :creator

end