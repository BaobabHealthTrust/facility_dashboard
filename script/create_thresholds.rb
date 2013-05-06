def load

  facility1 = AttendanceFigure.find_by_sql("SELECT distinct facility from attendance_figures")
  facility2 = AttendanceFigure.find_by_sql("SELECT distinct facility from health_care_indicators")

  facility1.each do |facility|

    new_threshold = FacilityThreshold.find(:first, :conditions => ["facility = ?",facility.facility])

    if new_threshold.nil?

      new_threshold = FacilityThreshold.new()

    end
    new_threshold.facility = facility.facility
    new_threshold.save!
  end

  facility2.each do |facility|

    new_threshold = FacilityThreshold.find(:first, :conditions => ["facility = ?",facility.facility])

    if new_threshold.nil?

      new_threshold = FacilityThreshold.new()

    end

    new_threshold.facility = facility.facility
    new_threshold.save!

  end

end

load