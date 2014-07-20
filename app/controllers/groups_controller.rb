class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    @mygroups = Group.find(current_user.group_id)
    @publicgroups = Group.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @events = Group.find(params[:id]).events
  end

  def join
    user = User.find(current_user.id)
    user.group_id = params[:id]
    @group = Group.find(user.group_id)
    respond_to do |format|
      if user.save
        format.html { redirect_to @group, notice: 'You were added to the group!' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end



  end


  def alert
    if session[:page_load] != nil then
      session[:page_load] += 1
    else
      session[:page_load] = 0
    end
    @queue_alerts = Alert.all.where.not(:is_sent => true)

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


  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  def notify_all
    Group.find(params[:id])
    members = Group.members
    

  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :desc)
    end
end
