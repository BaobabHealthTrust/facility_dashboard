
class EditsController < ApplicationController

  def messages
    check_login

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

  def add_user

  end

  def new_user

    exists = User.find_by_username(params[:username]) rescue nil

    if !exists.nil?
      flash[:error] = "Username already taken!"
      redirect_to "/edits/add_user"
      return
    end

    new_user = User.new(params[:user] )

    new_user.save
    redirect_to "/edits/add_user"
    return

  end

  def login
    render :layout =>  false
  end

  def verify_user

    state = User.authenticate(params[:user][:username],params[:user][:password])
    raise state.to_yaml
    if state
      redirect_to @return_path unless @return_path.nil?
      redirect_to "/"
    else
      flash[:messages] = "Wrong user password combination"
      redirect_to "/edits/login"
    end

  end

end