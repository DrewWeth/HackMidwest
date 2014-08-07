class ApplicationController < ActionController::Base
	before_action :configure_devise_permitted_parameters, if: :devise_controller?

	protected

	helper :all do

		def resource_name
			:user
		end

		def resource
			@resource ||= User.new
		end

		def devise_mapping
			@devise_mapping ||= Devise.mappings[:user]
		end
	end
	def configure_devise_permitted_parameters
		registration_params = [:country, :phone_num, :password, :password_confirmation, :email, :current_password]

		devise_parameter_sanitizer.for(:sign_up) { 
			|u| u.permit(registration_params) 
		}
		devise_parameter_sanitizer.for(:account_update) { 
			|u| u.permit(registration_params) 
		}

			
	end

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
