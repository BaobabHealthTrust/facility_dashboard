require 'ImageResize'

class CommonController < ApplicationController

  def index
    @facility = "Kamuzu Central Hospital"
  end
	
	def display_announcements

    @announcements = Message.find(:all, :conditions => ["msg_type = 'announcement'
      AND start_date <= ? and end_date >= ?",DateTime.now,DateTime.now])
	
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

    html = "<html><head></head><body><div style='position: absolute; left: 30px; " +
      "top: 30px;'><b>W:</b> #{size[0]}; <b>" +
      "H:</b> #{size[1]}</div><button onclick='var response = confirm(\"Do you really want " +
      "to delete this image?\"); if(response){window.location = \"/common/delete_image?upload_path_url=" +
      "#{params["upload_path_url"]}\";}' style='padding: 10px; position: absolute; top: 5px; " +
      "right: 5px; font-size: 24px;'>Delete</button><br /><br /><br /><br /><embed src='/data/#{params["upload_path_url"]}' " +
      "height='#{size[1]}' width='#{size[0]}' /> <script type='text/javascript'><!--\n " +
      "if(window.parent.document.getElementById('upload_path')){" +
      "window.parent.document.getElementById('upload_path').value = '#{params["upload_path_url"]}';" +
      "} \n//--></script></body></html>"
    
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

  def display_advert

    @advert = Message.find(:first, :conditions => ["msg_type = 'advertisement'
      AND start_date <= ? and end_date >= ?",DateTime.now,DateTime.now ])

  end

  def display_general_message

    @message = Message.find(:first,:conditions => ["msg_type = 'general message'
      AND start_date <= ? and end_date >= ?",DateTime.now,DateTime.now ])

  end

  def display_services

    @services = Service.find(:all, :conditions =>  ["available = ?", true])

  end

  def facility_attendance

     #@attendance =  AttendanceFigure.find_by_sql()

  end

end
