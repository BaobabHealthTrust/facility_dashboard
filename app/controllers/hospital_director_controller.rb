
class HospitalDirectorController < ApplicationController

  def facility
    @facility = "Kamuzu Central Hospital"

    @centers = ["Total Attendance"]

    @readings = Hash.new()

    @ranges = {}

    today = 0
    this_month = 0
    this_year = 0

    day_figures = AttendanceFigure.find(:all, :conditions => ["attendance_figure_day = ?", Date.today],
                                        :order => "attendance_figure DESC")
    month_totals = AttendanceFigure.find_by_sql("SELECT facility, SUM(attendance_figure) total,
                    Month(attendance_figure_day) month FROM attendance_figures WHERE
                    Year(attendance_figure_day) = Year(current_date)  GROUP BY facility,Month(attendance_figure_day)")


    day_figures.each do |todays_attendance|

      @readings[todays_attendance.facility] = [todays_attendance.attendance_figure, 0, 0]
      today += todays_attendance.attendance_figure

    end



    month_totals.each do |month_total|

      @centers << month_total.facility unless  !@centers.index(month_total.facility ).nil?


      if @readings[month_total.facility].blank?

        @readings[month_total.facility] = [0,0,0]

      end

      @readings[month_total.facility][2] += month_total.total.to_i

      if Date.today.month.to_s == month_total.month
        @readings[month_total.facility][1] = month_total.total.to_i
        this_month += month_total.total.to_i
      end

      this_year += month_total.total.to_i
    end


    @readings["Total Attendance"] = [today, this_month, this_year]


    (1..(@centers.length - 1)).each do |i|

      threshold = FacilityThreshold.find(:first, :conditions => ["facility = ?", @centers[i]])
      min = threshold.lower_limit rescue 20
      avg = threshold.average rescue 40
      max = threshold.upper_limit rescue 100
      @ranges[@centers[i]] = [[0,min, "blue"],[min+1, avg, "green"], [avg+1,max,"red"]]

    end

     #raise @ranges.to_yaml
  end

end