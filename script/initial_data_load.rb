def load_data

  health_care_updater = HealthCareIndicator.new
  attendance_updater = AttendanceFigure.new


    attendance_updater.update_values
    health_care_updater.update_values


end

load_data