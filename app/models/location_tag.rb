class LocationTag < ActiveRecord::Base

  set_primary_key :location_tag_id

  validates_presence_of :location_tag_name, :creator

end