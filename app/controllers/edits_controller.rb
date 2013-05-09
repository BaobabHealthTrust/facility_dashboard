
class EditsController < ApplicationController

 # before_filter :check_login, :except => [:login, :check_login, :verify_user]

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

  end

  def new_user
    exists = User.find(:first, :conditions => ["voided = 0 AND username = ?", params[:username]]) rescue nil

    if !exists.nil?
      render :text => "Username already taken!" and return
      redirect_to "/edits/add_user"
      return
    end

    new_user = User.new()
    new_user.password = params[:password ]
    new_user.username = params[:username]
    new_user.user_role = params[:user_role]
    new_user.save
    render :text =>  "User successfully created!" and return

  end

  def login
    
  end

  def verify_user
    state = User.authenticate(params[:user][:username],params[:user][:password])

    if state
      $current_user = User.find_by_username(params[:user][:username])
      redirect_to $return_path.nil? ? "/edits/admin" : $return_path

    else
      flash[:messages] = "Wrong user password combination"
      redirect_to "/edits/login"
    end

  end

  def delete_user
    @users =  User.find(:all, :conditions => ["voided = 0 AND user_id != 1"])
  end

  def delete

    void_users = User.find(:all,:conditions => ["user_id in (?)",params[:ids].split(",")])
    void_users.each do |user|
      user.voided = 1
      user.save

    end
    render :text => "User(s) successfully deleted" and return
  end

  def services
    @services = Service.find(:all, :conditions =>  ["available = ?", true])
  end

  def get_service

    service = Service.find(params[:id])

    render :json => [service.location_offered, service.service_name]

  end

  def delete_service
    service = Service.find(:first, :conditions => ["service_id = ?", params[:service_id]])
    service.available = false
    service.save!
    render :text => "true" and return
  end

  def update_service

    name = params[:name]
    location = params[:loc]
    status = params[:available] == "Available"? true : false

    new_service = Service.find(:first, :conditions => ["service_name = ?", name])

    if new_service.nil?
       new_service = Service.new()
    end

    new_service.service_name = name
    new_service.location_offered = location
    new_service.available = status
    new_service.save!

    render :text => "true" and return
  end

  def logout
    $current_user = nil
    $return_path = "/admin"
    redirect_to "/login"
  end

  def flow_reorder

    if params[:id] == "hos_dir"
      @target = "hos_dir_order_id"
      @show = "hos_dir"
    elsif params[:id] == "policy"
      @target = "policy_order_id"
      @show = "policy_maker"
    else
      @target = "consumer_order_id"
      @show = "consumer"
    end

    @flow = FlowOrder.find(:all, :conditions => ["(DATE(start_date) <= DATE(NOW()) " +
          "AND (DATE(end_date) > DATE(NOW()) OR COALESCE(end_date, '') = '')) OR (COALESCE(start_date, '') = '' " +
          "AND COALESCE(end_date, '') = '')"], :order => [@target])


    #raise @flow.inspect
  end

  def choose_audience

  end

  def update_flow_order

    target = params["target"]
    show = params["display_field"]
    #raise params.inspect
    (0..(params["src_id"].length - 1)).each do |i|

      new_position = FlowOrder.find(params["src_id"][i])
      new_position[target] = params["dst_id"][i]
      new_position.duration = params["duration"][i]
      new_position[show] = params["show"][(i+1).to_s] == "on" ? true : false
      new_position.start_date = params["start_date"][i]
      new_position.end_date = params["end_date"][i]
      new_position.save!
      #raise new_position.inspect
    end

    redirect_to :action => :choose_audience
  end

  def admin
  end

  def facility_thresholds

    @thresholds = FacilityThreshold.find(:all)
  end

  def get_facility_threshold

    threshold = FacilityThreshold.find(:first, :conditions => ["threshold_id = ?", params[:threshold_id]])

    render :json => [threshold.facility, threshold.lower_limit, threshold.average, threshold.upper_limit]

  end

  def delete_threshold

    FacilityThreshold.delete(params[:threshold_id] )

    render :text => "Threshold successfully deleted" and return

  end

  def update_threshold

    new_threshold = FacilityThreshold.find(:first, :conditions => ["facility = ?", params[:facility]])

    if new_threshold.nil?

      new_threshold = FacilityThreshold.new
      new_threshold.facility = params[:facility]
    end

    new_threshold.lower_limit = params[:lower_limit]
    new_threshold.average = params[:median]
    new_threshold.upper_limit = params[:upper_limit]
    new_threshold.save!

    render :text => "Thresholds successfully updated" and return

  end

  def facility_indicators

    @indicators = HealthCareIndicator.find(:all)

  end

end