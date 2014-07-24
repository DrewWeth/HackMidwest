class AlertsController < ApplicationController
  before_action :set_alert, only: [:show, :edit, :update, :destroy]

  # GET /alerts
  # GET /alerts.json
  def index
    @alerts = Alert.all
  end

  # GET /alerts/1
  # GET /alerts/1.json
  def show
    @event = Alert.find(params[:id])

  end

  # GET /alerts/new
  def new
    @alert = Alert.new
  end

  # GET /alerts/1/edit
  def edit
  end

  # POST /alerts
  # POST /alerts.json
  def create
    @alert = Alert.new(alert_params)
    @alert.is_sent = false
    event_for_alert = Event.find(@alert.event_id)
    group_for_event = Group.find(event_for_alert.group_id)
    @alert.body = group_for_event.name + "'s event: " + event_for_alert.name + " is happening: " + event_for_alert.start.strftime("%B %d, %Y at %I:%M %p") + "."

    respond_to do |format|
      if @alert.save
        
        format.html { redirect_to @alert, notice: 'Alert was successfully created.' }
        format.json { render :show, status: :created, location: @alert }
      else
        format.html { render :new }
        format.json { render json: @alert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /alerts/1
  # PATCH/PUT /alerts/1.json
  def update
    respond_to do |format|
      if @alert.update(alert_params)
        format.html { redirect_to @alert, notice: 'Alert was successfully updated.' }
        format.json { render :show, status: :ok, location: @alert }
      else
        format.html { render :edit }
        format.json { render json: @alert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alerts/1
  # DELETE /alerts/1.json
  def destroy
    @alert.destroy
    respond_to do |format|
      format.html { redirect_to alerts_url, notice: 'Alert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alert
      @alert = Alert.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def alert_params
      params.require(:alert).permit(:event_id, :send_datetime, :is_sent, :body, :group_id)
    end
end
