class EventsController < ApplicationController


  before_action :set_event, only: [:show, :edit, :update, :destroy]


  # GET /events
  # GET /events.json

  def index
    if current_user != nil
      time = Time.now
      groups = User.find(current_user.id).groups
      @events = []

      # written at 2:43am. this seems super inefficient
      groups.each do |g|
        g.events.each do |e|
          if !((e.start + ( 1.hours * e.duration)).past?)
            # (e.start - time)/1.days >= 0
            @events.push(e)
          end
        end
      end
      
      @events.sort! {|a, b| a.start <=> b.start}
      @public_events = Event.all.where(:is_public => true)

    else
      @events = []
      @public_events = Event.all.where(:is_public => true)
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
    @group = Group.find(@events.group_id)
    @owner = User.find(@events.user_id)
    @all_alerts = @events.alerts  # sent alerts i.e. not deletable
    @zone = ActiveSupport::TimeZone.new(@events.timezone) # Make new timezone for the event
    
    
    @has_attended = false
    if current_user != nil
      confirmation_list = Confirmation.where(:user_id => current_user.id).where(:event_id => params[:id]).take
      if confirmation_list != nil
        @has_attended = true 
      end
    end
    session[:event_id] = params[:id]

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
    if current_user != nil
      if session[:group_id] == nil
        redirect_to events_url
      else
        @event = Event.new
      end
    else
      redirect_to new_user_session_path
    end
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  # POST /events.json
  def create
    if current_user != nil
      @event = Event.new(event_params)
      
      # Get group for event
      @event.group_id = session[:group_id]
      group_for_event = Group.find(@event.group_id)

      # Set event owner to current user
      @event.user_id = current_user.id
      
      zone = ActiveSupport::TimeZone.new(@event.timezone) # Make new timezone for the event
      o = zone.utc_offset + 1.hour # Get offset of events zone      
      @event.start = @event.start - o # Offset by the timezone

      respond_to do |format|
        if @event.save
          # if params[:alert_template] == '1'
          #   arr_alerts = [72, 24, 0] # Alerts are in hours away
          if params[:alert_template] == '2'
            arr_alerts = [24, 3, 0] # Alerts are in hours away
          elsif params[:alert_template] == '3'
            arr_alerts = [3, 0] # Alerts are in hours away
          else params[:alert_template] == '4'
            arr_alerts = [0] # Alerts are in hours away
          end
          # has to be after event.save to be assigned a PK
          url_string = root_url + "events/" + @event.id.to_s

          # Dev notes
          # ---------
          # Since everything is based around Alerts, only the alert sendtime is kept in servertime
          # Alert server time is calculated with event's start datetime and timezone
          # Event times should be kept in local times.
          # initial alert

          alert = Alert.new
          alert.event_id = @event.id
          alert.send_datetime = Time.now
          alert.body = group_for_event.name + "'s event, " + @event.name + ", is on " + @event.start.strftime("%B %d, %Y at %I:%M %p")
          alert.save

          # 'temporal alerts'
          arr_alerts.each do |a|
            alert = Alert.new
            alert.event_id = @event.id

            alert.send_datetime = @event.start.in_time_zone - a.hours # set time from start to do send

            if a == 0
              alert.is_event_start = true
              alert.body = group_for_event.name + "'s event, " + @event.name + ", has started!. Sign in here: " + url_string
            else
              alert.is_event_start = false
              if a <= 24
                alert.body = group_for_event.name + "'s event, " + @event.name + ", starts in " + a.to_s + " hours."
              else
                alert.body = group_for_event.name + "'s event, " + @event.name + ", starts in " + ((a/1.day).to_s) + " days."
              end
            end    
            alert.save
          end

          

          format.html { redirect_to @event, notice: 'event was successfully created' }
          format.json { render :show, status: :created, location: @event }
        else
          format.html { render :new }
          format.json { render json: @event.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'must be logged in to make event' }
        format.json { render :show, status: :created, location: root_path }
      end
    end
  end

  # PATCH/PUT /events/1
  # PATCH/PUT /events/1.json
  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to @event, notice: 'event was successfully updated' }
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

      params.require(:event).permit(:name, :desc, :start, :duration, :location, :address, :latitude, :longitude, :is_public, :group_id, :duration, :timezone)
    end



  end
