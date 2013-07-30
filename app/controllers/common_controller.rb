require 'ImageResize'
require "miro"

class CommonController < ApplicationController

  def index

    $audience = params[:id] rescue "consumer"
    if params[:id] =="p"
      $audience = "policy_maker"
      $order = "policy_order_id"
    elsif params[:id] == "h"
      $audience = "hos_dir"
      $order = "hos_dir_order_id"
    else
      $audience = "consumer"
      $order = "consumer_order_id"
    end
    if $slide.nil?
      $slide = SlideEngine.new
      
      $slide.reset_slides
    end

    i = 0
    @news = Message.find(:all, :select => ["msg_id, msg_id * RAND() AS "+
          "random_no, msg_type, heading, msg_text, start_date, end_date"], :order => "random_no", :limit => 10,
      :conditions => ["msg_type = 'announcement' AND start_date <= ? and end_date >= ?",
        DateTime.now, DateTime.now]).collect{|n|
      i += 1;
      "<span style='color: #{cycle("#cfe7f5", "#dc9746", i)}'><b>#{n.heading}:</b> " +
        "#{n.msg_text[0..100]}#{(n.msg_text.length > 100 ? "..." : "")}</span>"
    }.join("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ")

    @news = "No Announcements" if @news.strip.blank?

    render :layout => false
  end
	
  def home    
  end

	def announcements

    @announcement = Message.find(:first, :select => ["msg_id, msg_id * RAND() AS "+
          "random_no, msg_type, heading, msg_text, start_date, end_date, duration, content_path, media_bg_color"],
      :order => "random_no", :limit => 10,
      :conditions => ["msg_type = 'announcement' AND start_date <= ? and end_date >= ?",
        DateTime.now, DateTime.now])

    @duration = @announcement.duration rescue 1

    @heading = @announcement.heading rescue "&nbsp;"

    @text = @announcement.msg_text rescue "&nbsp;"

    @media = @announcement.content_path rescue ""

    @media_bg_color = @announcement.media_bg_color rescue "#000000"

    if !@media.blank?
      @media = "/data/#{@media}"
    end

	end
  
  def uploadfile
    render :layout => false
  end

	def upload_selected_file

    if File.exist?("#{Rails.root}/public/data/#{params["upload_path_url"]}")

      path = params["upload_path_url"].strip.downcase.match(/(.+)\.([^\.]+)$/)

      root = "#{Rails.root}/public/data/"

      i = 1
      while File.exist?("#{root}#{path[1]}_#{i}.#{path[2]}")
        i += 1
      end

      params["upload_path_url"] = "#{path[1].strip}_#{i}.#{path[2].strip}"

    end

    post = DataFile.save(params[:upload], params["upload_path_url"])

    Image.resize("#{Rails.root}/public/data/#{params["upload_path_url"]}", 
      "#{Rails.root}/public/data/resized_#{params["upload_path_url"]}", 670, 500)

    if File.exist?("#{Rails.root}/public/data/resized_#{params["upload_path_url"]}")
      
      File.delete("#{Rails.root}/public/data/#{params["upload_path_url"]}")

      File.rename("#{Rails.root}/public/data/resized_#{params["upload_path_url"]}",
        "#{Rails.root}/public/data/#{params["upload_path_url"]}")

    end
    
    size = get_image_size("#{Rails.root}/public/data/#{params["upload_path_url"]}")

    size = [670, 500] if size.nil?

    colors = Miro::DominantColors.new("#{Rails.root}/public/data/#{params["upload_path_url"]}") rescue nil

    color = colors.to_hex rescue ["#000000"]

    html = "<html><head></head><body style='background-color: #{color[0]}; color: #fff'><div style='position: absolute; left: 30px; " +
      "top: 30px;'><b>W:</b> #{size[0]}; <b>" +
      "H:</b> #{size[1]}</div><button onclick='var response = confirm(\"Do you really want " +
      "to delete this image?\"); if(response){window.location = \"/common/delete_image?upload_path_url=" +
      "#{params["upload_path_url"]}\";}' style='padding: 10px; position: absolute; top: 5px; " +
      "right: 5px; font-size: 24px;'>Delete</button><br /><br /><br /><br /><embed src='/data/#{params["upload_path_url"]}' " +
      "height='#{size[1]}' width='#{size[0]}' /> <script type='text/javascript'><!--\n " +
      "if(window.parent.document.getElementById('upload_path')){" +
      "window.parent.document.getElementById('upload_path').value = '#{params["upload_path_url"]}';}" +
      "if(window.parent.document.getElementById('content_type')){" +
      "window.parent.document.getElementById('content_type').value = '#{color[0]}';}" +
      "if(window.parent.document.getElementById('media_bg_color')){" +
      "window.parent.document.getElementById('media_bg_color').value = '#{color[0]}';}" +
      "if(window.parent.document.getElementById('width')){" +
      "window.parent.document.getElementById('width').value = '#{size[0]}';}" +
      "if(window.parent.document.getElementById('height')){" +
      "window.parent.document.getElementById('height').value = '#{size[1]}';}" +
      " \n//--></script></body></html>"
    
    render :text => html
  end

  def delete_image

    if File.exist?("#{Rails.root}/public/data/#{params["upload_path_url"]}")

      File.delete("#{Rails.root}/public/data/#{params["upload_path_url"]}")
      
    end

    redirect_to :action => :uploadfile
  end

  def get_image_size(image)
    if image.downcase.match(/\.png$/)
      
      IO.read(image)[0x10..0x18].unpack('NN')

    elsif image.downcase.match(/\.gif$/)

      IO.read(image)[6..10].unpack('SS')

    elsif image.downcase.match(/\.bmp$/)

      d = IO.read(image)[14..28]
      d[0] == 40 ? d[4..-1].unpack('LL') : d[4..8].unpack('SS')

    elsif image.downcase.match(/\.jpg$|\.jpeg$/)
      file = JPEG.new(image)

      [file.width, file.height]
    end
  end

  def advert

    @advert = Message.find_by_msg_id(params[:id])

    @duration = @advert.duration.to_i rescue 0

    @media = @advert.content_path rescue ""

    if @media.blank?
      @media = "/images/coatOfArms.png"
    else
      @media = "/data/#{@media}"
    end

    height = @advert.media_height rescue 500
    width = @advert.media_width rescue 500

    height = 500 if height.nil?
    width = 500 if width.nil?
    
    if height > width
      @width = "100%"
      @height = "#{(width.to_f / height.to_f) * 100}%"
    elsif width > height
      @height = "100%"
      @width = "#{(height.to_f / width.to_f) * 100}%"
    else
      @height = "#{height}px"
      @width = "#{width}px"
    end

    params[:duration] = @duration
    
  end

  def general_message

    unless params[:id].blank?

      @message = Message.find(:first, :select => ["msg_id, msg_id * RAND() AS "+
            "random_no, msg_type, msg_group, heading, msg_text, start_date, end_date, " +
            "duration, media_height, media_width, content_path, media_bg_color"],
        :order => "random_no",
        :conditions => ["msg_type = 'general message' AND start_date <= ? AND " +
            "end_date >= ? AND msg_id = ?", DateTime.now, DateTime.now, params[:id]])

    else

      @message = Message.find(:first, :select => ["msg_id, msg_id * RAND() AS "+
            "random_no, msg_type, msg_group, heading, msg_text, start_date, end_date, " +
            "duration, media_height, media_width, content_path, media_bg_color"],
        :order => "random_no",
        :conditions => ["msg_type = 'general message'
      AND start_date <= ? and end_date >= ?",DateTime.now, DateTime.now ])

    end

    @category = @message.msg_group rescue nil

    @duration = @message.duration.to_i rescue 0

    @media = @message.content_path rescue ""

    @media_bg_color = @message.media_bg_color rescue "#000000"

    if @media.blank?
      @media = "/images/coatOfArms.png"
    else
      @media = "/data/#{@media}"
    end

    height = @message.media_height rescue 500
    width = @message.media_width rescue 500

    height = 500 if height.nil?
    width = 500 if width.nil?

    if height < width
      @width = "100%"
      @height = "#{(width.to_f / height.to_f) * 100}%"
    elsif width > height
      @height = "100%"
      @width = "#{(height.to_f / width.to_f) * 100}%"
    else
      @height = "#{height}px"
      @width = "#{width}px"
    end

  end

  def facility_services

    @services = Service.find(:all, :conditions =>  ["available = ? AND voided =?", true, false])

  end

  def facility_indicators
    @facility = "Kamuzu Central Hospital"

    @centers = []
    @ranges = { }
    @readings = Hash.new()

    today = 0
    this_month = 0
    this_year = 0

    day_figures = HealthCareIndicator.find(:all, :conditions => ["indicator_date = ? AND indicator_type != 'admission'", Date.today])
    month_totals = HealthCareIndicator.find_by_sql("SELECT indicator_type, SUM(indicator_value) total,
                    Month(indicator_date) month FROM health_care_indicators WHERE indicator_type IN ('Total Admissions') AND
                    Year(indicator_date) = Year(current_date)  GROUP BY indicator_type,Month(indicator_date)")



    day_figures.each do |todays_indicators|

      @readings[todays_indicators.indicator_type ] = [todays_indicators.indicator_value,0,0]
      @centers << todays_indicators.indicator_type

    end


    month_totals.each do |month_total|

      @centers << month_total.indicator_type unless !@centers.index(month_total .indicator_type).nil?

      if @readings[month_total.indicator_type].blank?
        @readings[month_total.indicator_type] = [0,0,0]
      end

      @readings[month_total.indicator_type][2] += month_total.total.to_i

      if Date.today.month.to_s == month_total.month
        @readings[month_total.indicator_type][1] = month_total.total.to_i

      end



    end





    (1..(@centers.length - 1)).each do |i|

      threshold = FacilityThreshold.find(:first, :conditions => ["facility = ?", @centers[i]])
      min = threshold.lower_limit rescue 20
      avg = threshold.average rescue 40
      max = threshold.upper_limit rescue 100
      @ranges[@centers[i]] = [[0,min, "blue"],[min+1, avg, "green"], [avg+1,max,"red"]]

    end

  end


  def trends

    start_date = Date.today - 4.days
    end_date = Date.today
    r = {}
    @max = 0
    @days = [[0," "],[6," "] ]
    x_values={}

    (0..4).each do |i|
      @days << [ x_values[(start_date + i.days ).strftime('%A')]= i+1 ,(start_date + i.days ).strftime('%A')]
    end



    day_total = AttendanceFigure.find(:all,
      :conditions => ["attendance_figure_day BETWEEN ? AND ?",start_date , end_date ],
      :order => "attendance_figure_day ASC")

    day_total.each do |x|

      if r[x.facility].blank?
        r[x.facility] = [[ x_values[x.attendance_figure_day.strftime('%A')],x.attendance_figure]]
      else
        r[x.facility] << [x_values[x.attendance_figure_day.strftime('%A')] ,x.attendance_figure]
      end

      @max = x.attendance_figure unless @max >x.attendance_figure

    end

    @data_list = "["
    r.each do |d|
      @data_list += "{data:"+ d[1].to_json + ", label:'" + d[0]+ "' , lines: {show:true }, points: {show:true }},"
    end

    @data_list += "]"
    @max += 50
  end

  def catchment_areas

    @areas = CatchmentArea.find(:all)


  end

  def area_attendance

    @centers = ["Total Attendance"]
    @ranges = {}
    @readings = Hash.new()

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




  end

  def retrieve_announcements
    i = 0
    @news = Message.find(:all, :select => ["msg_id, msg_id * RAND() AS "+
          "random_no, msg_type, heading, msg_text, start_date, end_date"], :order => "random_no", :limit => 10,
      :conditions => ["msg_type = 'announcement' AND start_date <= ? and end_date >= ?",
        DateTime.now, DateTime.now]).collect{|n|
      i += 1;
      "<span style='color: #{cycle("#cfe7f5", "#dc9746", i)}'><b>#{n.heading}:</b> " +
        "#{n.msg_text[0..100]}#{(n.msg_text.length > 100 ? "..." : "")}<span>"
    }.join("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; ")

    @news = "No Announcements" if @news.strip.blank?

    render :text => @news
  end

  def site_attendance

    @centers = ["Total Attendance"]

    @readings = Hash.new()

    today = 0
    this_month = 0
    this_year = 0

    day_figures = AttendanceFigure.find(:all, :conditions => ["attendance_figure_day = ?", Date.today],
                                        :order => "attendance_figure DESC")
    month_totals = AttendanceFigure.find_by_sql("SELECT location_created, SUM(attendance_figure) total,
                            Month(attendance_figure_day) month FROM attendance_figures WHERE
                            Year(attendance_figure_day) = Year(current_date)
                            GROUP BY location_created,Month(attendance_figure_day)")


    day_figures.each do |todays_attendance|

      @readings[todays_attendance.location_created] = [todays_attendance.attendance_figure, 0, 0]
      today += todays_attendance.attendance_figure

    end



    month_totals.each do |month_total|

      @centers << month_total.location_created unless  !@centers.index(month_total.location_created ).nil?


      if @readings[month_total.location_created].blank?

        @readings[month_total.location_created] = [0,0,0]

      end

      @readings[month_total.location_created][2] += month_total.total.to_i

      if Date.today.month.to_s == month_total.month
        @readings[month_total.location_created][1] = month_total.total.to_i
        this_month += month_total.total.to_i
      end

      this_year += month_total.total.to_i
    end


    @readings["Total Attendance"] = [today, this_month, this_year]

    @ranges = {

        "Ward 2B" =>  [
            [0, 20, "blue"],
            [21, 40, "green"],
            [41, 60, "red"]
        ]
    }

  end

  def notice_board

    @announcements = Message.find(:all, :select => ["msg_id, msg_id * RAND() AS random_no, msg_type, heading, msg_text"+
                                                         ", start_date, end_date, duration, content_path, media_bg_color"],
                                 :order => "random_no", :limit => 10,
                                 :conditions => ["msg_type = 'announcement' AND start_date <= ? and end_date >= ?",
                                                 DateTime.now, DateTime.now])



  end


  def admissions

    @centers = ["Total Attendance"]
    @ranges = {}
    @readings = Hash.new()

    today = 0
    this_month = 0
    this_year = 0

    day_figures = HealthCareIndicator.find(:all, :conditions => ["indicator_date = ? AND indicator_type = 'admission'",
                                                                Date.today], :order => "indicator_value DESC")
    month_totals = HealthCareIndicator.find_by_sql("SELECT facility, SUM(indicator_value) total,
                    Month(indicator_date) month FROM health_care_indicators WHERE  indicator_type = 'admission' AND
                    Year(indicator_date) = Year(current_date)  GROUP BY facility,Month(indicator_date)")


    day_figures.each do |todays_attendance|

      @readings[todays_attendance.facility] = [todays_attendance.indicator_value, 0, 0]
      today += todays_attendance.indicator_value

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


  end

  protected
  

end
