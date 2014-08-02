class AccountsController < ApplicationController

	def unsync
		if current_user != nil
			user = User.find(current_user.id)
			user.restriction_level = 1
			user.save
			redirect_to edit_user_registration_path 
		else
			redirect_to root_path
		end
	end

	def remove_restrictions
		if current_user != nil
			user = User.find(current_user.id)
			user.restriction_level = 0
			user.save
			redirect_to edit_user_registration_path 
		else
			redirect_to root_path
		end
	end

	def ban
		if current_user != nil
			user = User.find(current_user.id)
			user.restriction_level = 2
			user.save
		else
			redirect_to root_path
		end
	end

	
end
