# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#   
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)

User.create(:username => 'admin', :password => 'test', :user_role => 'admin', :voided => 0)

FlowOrder.create(
  [
    { 
      :order_group => "facility attendance",
      :description => "Facility attendance figures",
      :duration => 0.4,
      :creator => 1
    },
    {
      :order_group => "area attendance",
      :description => "Area attendance figures of facilities",
      :duration => 0.4,
      :creator => 1
    },
    {
      :order_group => "facility services",
      :description => "Services offered at facility",
      :duration => 0.3,
      :creator => 1
    },
    {
      :order_group => "trends",
      :description => "Trends view",
      :duration => 0.4,
      :creator => 1
    },
    {
        :order_group => "notice board",
        :description => "List of ten announcements",
        :duration => 0.4,
        :creator => 1
    }
=begin
,    ,
    {
      :order_group => "facility indicators",
      :description => "Indicators of  services offered at facility",
      :duration => 0.4,
      :creator => 1
    }   ,
    {
      :order_group => "catchment areas",
      :description => "Facility catchment areas view",
      :creator => 1
    }
=end
  ]
)

# To create seed:
# File.open('test/messages.json', 'w') { |f| f << Message.all.to_json }

if File.exist?("test/messages.json")
  
  json = ActiveSupport::JSON.decode(File.read('test/messages.json'))

  json.each do |a|
    Message.create!(a["message"])
  end

end