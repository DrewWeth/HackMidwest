class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  # GET /events
  # GET /events.json


  def index
    if params[:id] != nil
      @events = Event.all.where(group_id: params[:id])
    else
      @events = Event.all
    end

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @events }
    end
  end

  # GET /events/1
  # GET /events/1.json
  def show
    @events = Event.find(params[:id])

    @all_alerts = @events.alerts
    @queue_alerts = @events.alerts.where.not(:is_sent => true)

    require 'twilio-ruby'
    puts "Twilio authentication"
    account_sid = 'AC29e7b96239c5f0bfc6ab8b724e263f30'
    auth_token = 'e9befab8a2ea884e92db21709fe073e1'
    
    begin
      @client = Twilio::REST::Client.new account_sid, auth_token
    rescue Twilio::RESR::RequestError => e
      puts e.message
    end
    @queue_alerts.each do |u|
      puts "IS IT PAST DATE???" + u.send_datetime.past?.to_s
      if u.send_datetime.past?
        the_event = Event.find(u.event_id)
        the_group = Group.find(the_event.group_id)
        list_of_nums = the_group.users
        puts "Got here"
        list_of_nums.each do |l|
          mob_num = "+1" + l.phone_num.to_s
          puts "Phone number:: " + mob_num.to_s 
          @client.account.messages.create(
            :from => '+13147363270',
            :to => mob_num,
            :body => u.body )
          u.is_sent = true
          u.save
        end
      end
    end
  end

  # method to verify if user at event
  def checkIn
    if params[:id].present?
      @events = Event.find(params[:id])
      lat = @events.latitude
      long = @events.longitude
      # get location of browser from cookie
      @lat_lng = cookies[:lat_lng].split("|")
      distance = @events.distance_to(@lat_lng)

      # for now, just show with distance
      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @events }
      end

    else 
      # no event specified, throw error

    end
  end

  def view


  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create

    @event = Event.new(event_params)

    respond_to do |format|
      if @event.save
        
        log = Alert.new
        log.event_id = @event.id
        log.send_datetime = @event.start
        log.is_event_start = true
        log.is_sent = false;
        group_for_event = Group.find(@event.group_id)
        url_string = root_url + "confirmations/new?user_id=" + current_user.id.to_s + "&event_id=" + @event.id.to_s
        log.body = "!!! " + group_for_event.name + "'s event: " + @event.name + " has started!. Sign in here: " + url_string
        

        log.save

        format.html { redirect_to @event, notice: 'Event was successfully created.' }
        format.json { render :show, status: :created, location: @event }
      else
        format.html { render :new }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'Event was successfully updated.' }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.json
  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params

      params.require(:event).permit(:name, :desc, :start, :end, :location, :address, :latitude, :longitude, :is_public, :group_id)
    end
  end
