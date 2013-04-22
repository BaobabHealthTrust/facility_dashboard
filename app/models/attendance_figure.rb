class AttendanceFigure < ActiveRecord::Base

  set_primary_key :attendance_figure_id

  belongs_to :location_tag, :foreign_key => :location_tag_id


end