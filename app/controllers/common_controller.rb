require 'ImageResize'
require "miro"

class CommonController < ApplicationController

  def index
    if SlideEngine.slide_show.length == 0
      SlideEngine.new
      
      SlideEngine.reset_slides
    else
      SlideEngine.new
    end

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

    # @duration = 2 if @duration < 1

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
=begin
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
=end
    @height = "100%"
    @width = "100%"
  end

  def services

    @services = Service.find(:all, :conditions =>  ["available = ?", true])

  end

  def facility_attendance

    #@attendance =  AttendanceFigure.find_by_sql()

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
      :conditions => ["attendance_figure_day BETWEEN ? AND ?",start_date , end_date ])

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
    @max +=50
  end

  def next_path
    
    SlideEngine.move_to_next_slide

    current_slide = SlideEngine.current_slide

    # raise SlideEngine.current_slide.to_yaml

    redirect_to SlideEngine.slide_show[current_slide]
  end

  protected
  

end
