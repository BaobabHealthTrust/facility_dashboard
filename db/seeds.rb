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
      :creator => 1
    },
    {
      :order_group => "area attendance",
      :description => "Area attendance figures of facilities",
      :creator => 1
    },
    {
      :order_group => "facility services",
      :description => "Services offered at facility",
      :creator => 1
    },
    {
      :order_group => "facility indicators",
      :description => "Indicators of  services offered at facility",
      :creator => 1
    },
    {
      :order_group => "trends",
      :description => "Trends view",
      :creator => 1
    },
    {
      :order_group => "catchment areas",
      :description => "Facility catchment areas view",
      :creator => 1
    }
  ]
)

# To create seed:
# File.open('messages.json', 'w') { |f| f << Message.all.to_json }

if File.exist?("test/messages.json")
  
  json = ActiveSupport::JSON.decode(File.read('test/messages.json'))

  json.each do |a|
    Message.create!(a["message"])
  end

end