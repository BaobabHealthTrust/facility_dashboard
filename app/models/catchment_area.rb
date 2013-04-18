class CatchmentArea < ActiveRecord::Base

  set_primary_key :catchment_area_id

  belongs_to :location,  :foreign_key => :location_id

end