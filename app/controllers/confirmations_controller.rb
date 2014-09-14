class ConfirmationsController < ApplicationController
  before_action :set_confirmation, only: [:show, :edit, :update, :destroy]

  # GET /confirmations
  # GET /confirmations.json
  def index
    @confirmations = Confirmation.all
  end

  # GET /confirmations/1
  # GET /confirmations/1.json
  def show
  end

  # GET /confirmations/new
  def new
    if current_user == nil
      redirect_to request.referer
    end
  end

  # GET /confirmations/1/edit
  def edit
  end

  # POST /confirmations
  # POST /confirmations.json
  def create
    redirect_to request.referer
  end


  def checkin
    event = Event.find(params[:id])

    distance = event.distance_to([params[:latitude], params[:longitude]])
    puts distance

    @confirmation = Confirmation.new

    if ( distance < 0.5 )
      @confirmation.event_id = params[:id]
      @confirmation.user_id = current_user.id


      respond_to do |format|
        if @confirmation.save
          message = "checkin successful. distance: " << distance.round(1).to_s << " miles"
          format.html { redirect_to event, notice: message }
          format.json { render :show, status: :created, location: @confirmation }
        else
          format.html { render :new }
          format.json { render json: @confirmation.errors, status: :unprocessable_entity }
        end
      end
    else
      message = "you are too far to check in! distance: " << distance.to_s << " miles. Lat: " + params[:latitude] + ". Long: " + params[:longitude]
      respond_to do |format|
        format.html { redirect_to event, notice: message }
        format.json { render json: @confirmation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /confirmations/1
  # PATCH/PUT /confirmations/1.json
  def update
    respond_to do |format|
      if @confirmation.update(confirmation_params)
        format.html { redirect_to :event => "show", :id => @confirmation.event_id }
        format.json { render :show, status: :ok, location: @confirmation }
      else
        format.html { render :edit }
        format.json { render json: @confirmation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /confirmations/1
  # DELETE /confirmations/1.json
  def destroy
    @confirmation.destroy
    respond_to do |format|
      format.html { redirect_to confirmations_url, notice: 'Confirmation was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_confirmation
      @confirmation = Confirmation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def confirmation_params
      params.require(:confirmation).permit(:user_id, :event_id)
    end
  end
