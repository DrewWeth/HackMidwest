class UsersController < ApplicationController
	# GET /users/1
	# GET /users/1.json
	def show
		@user = User.find(params[:id])
			
		if current_user != nil 
			
			user_groups = @user.groups
			current_user_groups = User.find(current_user.id).groups

			@intersect = user_groups & current_user_groups
		else
			@intersect = []
		end	
		@groups = @user.groups
	end	

end