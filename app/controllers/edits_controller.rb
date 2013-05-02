
class EditsController < ApplicationController

  before_filter :check_login, :except => [:login, :check_login, :verify_user]

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

  def add_user    
    render :layout =>  false
  end

  def new_user
    exists = User.find(:first, :conditions => ["voided = 0 AND username = ?", params[:user][:username]]) rescue nil

    if !exists.nil?
      flash[:message] = "Username already taken!"
      redirect_to "/edits/add_user"
      return
    end

    new_user = User.new()
    new_user.password = params[:user][:password ]
    new_user.username = params[:user][:username]
    new_user.user_role = params[:user][:user_role]
    new_user.save
    flash[:message] = "User successfully created!"
    redirect_to "/edits/add_user"
    return

  end

  def login
    render :layout =>  false
  end

  def verify_user
    state = User.authenticate(params[:user][:username],params[:user][:password])

    if state
      $current_user = params[:user][:username]
      redirect_to $return_path.nil? ? "/edits/messages" :$return_path

    else
      flash[:messages] = "Wrong user password combination"
      redirect_to "/edits/login"
    end

  end

  def delete_user
    @users =  User.find(:all, :conditions => ["voided = 0 AND user_id != 1"])

    render :layout =>  false
  end

  def delete
      void_users = User.find(:all,
      :conditions => ["user_id in (?)",
        params[:user].collect{|x| x[0] unless x[1].to_i==0 }])

    void_users.each do |user|
      user.voided = 1
      user.save

    end
    redirect_to "/edits/delete_user"
  end

  def services
    @services = Service.find(:all, :conditions =>  ["available = ?", true])
  end

  def delete_service
  end

  def logout
    $current_user = nil
    redirect_to "/login"
  end

  def flow_reorder
    @flow = FlowOrder.find(:all, :conditions => ["(DATE(start_date) <= DATE(NOW()) " +
          "AND DATE(end_date) > DATE(NOW())) OR (COALESCE(start_date, '') = '' " +
          "AND COALESCE(end_date, '') = '')"], :order => [:order_id])

    render :layout =>  false
  end

  def update_flow_order

    (0..(params["src_id"].length - 1)).each do |i|
      FlowOrder.update(params["src_id"][i], :order_id => params["dst_id"][i])
    end

    redirect_to :action => :flow_reorder
  end

end