def add

  FlowOrder.create(
      {
          :order_group => "admission figures",
          :description => "Number of patients admitted per ward",
          :duration => 0.4,
          :creator => 1
      }
  )

end

add