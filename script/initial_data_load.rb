def load_data

  check_attendance_figures =  AttendanceFigure.first
  check_health_care = HealthCareIndicator.first
  health_care_updater = HealthCareIndicator.new
  attendance_updater = AttendanceFigure.new

  if check_attendance_figures.blank?
    attendance_updater.update_values
  end

  if check_health_care.blank?
    health_care_updater.update_values
  end

end

load_data