class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    if current_user != nil
      @mygroups = User.find(current_user.id).groups
    else
      @mygroups = []
    end
    @publicgroups = Group.all
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    group = Group.find(params[:id])
    @owner = User.find(group.user_id)
    @is_member = false
    
    if current_user != nil
    
      @events = group.events
      @members = group.users

      selected_group = Group.find(params[:id])
      memberships = User.find(current_user.id).groups
      if memberships.include?(selected_group)
        @is_member = true
      end
      session[:group_id] = params[:id]
    else
      @events = Group.find(params[:id]).events.where(is_public: true)
    end
  end

  def join
    if current_user != nil
      @group = Group.find(params[:group_id])
          
      if params[:request_string] == @group.request_string

        # actually add member to group
        membership = Membership.new
        membership.user_id = current_user.id
        membership.group_id = params[:group_id]
        

        respond_to do |format|
          if membership.save

            # increase member count
            @group.member_count += 1
            @group.save


            format.html { redirect_to @group, notice: 'you were added to the group!' }
            format.json { render :show, status: :ok, location: @group }
          else
            format.html { render :edit }
            format.json { render json: @group.errors, status: :unprocessable_entity }
          end
        end
      else
        respond_to do |format|

          format.html { redirect_to @group, notice: 'secret password did not work' }
        end
      end
    else
      redirect_to new_user_session_path
    end
  end

  def leave
    group = Group.find(params[:id])
    # decrements member count and if no one is in it, then make it inactive
    group.member_count -= 1
    if group.member_count == 0
      group.is_active = false
    end
    group.save

    member = Membership.where(user_id: current_user.id).where(group_id: params[:id]).take
    Membership.delete(member.id)
    redirect_to groups_path
  end



  # GET /groups/new
  def new
    if current_user != nil
      @group = Group.new
    else
      redirect_to new_user_session_path
    end
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
    @group.user_id = current_user.id
    
    respond_to do |format|
      if @group.save
        membership = Membership.new
        membership.user_id = current_user.id
        membership.group_id = @group.id
        membership.save

        
        format.html { redirect_to @group, notice: 'group was successfully created.' }
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
        format.html { redirect_to @group, notice: 'group was successfully updated.' }
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
      format.html { redirect_to groups_url, notice: 'group was successfully destroyed.' }
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
      params.require(:group).permit(:name, :desc, :request_string)
    end
end
