def add

  FlowOrder.create(
      [
        {
          :order_group => "admission figures",
          :description => "Number of patients admitted per ward",
          :duration => 0.4,
          :creator => 1
        } ,
        {
          :order_group => "facility indicators",
          :description => "Indicators of  services offered at facility",
          :duration => 0.4,
          :creator => 1
        }
      ]
  )

end

add