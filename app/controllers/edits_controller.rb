
class EditsController < ApplicationController

  def messages    
  end

  def add_message
    # raise params.to_yaml
    
    saved = Message.create(
      :msg_type => params["message_type"],
      :msg_group => params["message_group"],
      :heading => params["heading"],
      :msg_text => params["message_text"],
      :duration => params["duration"],
      :media_width => params["width"],
      :media_height => params["height"],
      :content_path => params["upload_path"],
      :media_bg_color => params["media_bg_color"],
      :start_date => params["start_date"],
      :end_date => params["end_date"],
      :created_at => Time.now
    )

    flash[:notice] = "Message saved!"

    redirect_to :action => :messages
  end

end