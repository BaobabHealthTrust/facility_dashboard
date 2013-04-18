
class HospitalDirectorController < ApplicationController

  def facility
    @facility = "Kamuzu Central Hospital"

    @centers = ["Total Attendance", "Ward 1A", "Ward 1B", "Ward 2A", "Ward 2B",
      "Ward 3A", "Ward 3B", "Ward 4A", "Ward 4B"]

    @readings = {
      "Ward 1A" => [100, 30, 50],
      "Ward 1B" => [30, 10, 30],
      "Ward 2A" => [0, 0, 60],
      "Ward 2B" => [40, 0, 80],
      "Ward 3A" => [0, 0, 100],
      "Ward 3B" => [120, 1200, 3000],
      "Ward 4A" => [0, 0, 0],
      "Ward 4B" => [0, 0, 0]
    }

    today = 0
    this_month = 0
    this_year = 0
    
    @readings.each{|reading, value|
      today = today + @readings[reading][0]
      this_month = this_month + @readings[reading][1]
      this_year = this_year + @readings[reading][2]
    }

    @readings["Total Attendance"] = [today, this_month, this_year]
    
    @ranges = {
      "Ward 1A" => [
        [0, 20, "blue"],
        [21, 40, "green"],
        [41, 60, "red"]
      ],
      "Ward 1B" =>  [
        [0, 20, "blue"],
        [21, 40, "green"],
        [41, 60, "red"]
      ],
      "Ward 2A" =>  [
        [0, 20, "blue"],
        [21, 40, "green"],
        [41, 60, "red"]
      ],
      "Ward 2B" =>  [
        [0, 20, "blue"],
        [21, 40, "green"],
        [41, 60, "red"]
      ],
      "Ward 3A" =>  [
        [0, 20, "blue"],
        [21, 40, "green"],
        [41, 60, "red"]
      ],
      "Ward 3B" =>  [
        [0, 20, "blue"],
        [21, 40, "green"],
        [41, 60, "red"]
      ],
      "Ward 4A" =>  [
        [0, 20, "blue"],
        [21, 40, "green"],
        [41, 60, "red"]
      ],
      "Ward 4B" =>  [
        [0, 20, "blue"],
        [21, 40, "green"],
        [41, 60, "red"]
      ]
    }

    # raise @ranges["Ward 4B"][0][0].to_yaml
  end

end