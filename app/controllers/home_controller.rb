class HomeController < ApplicationController

	def index
		@users = User.all.count
		@groups = Group.all.count	
		@events = Event.all.count
		@alerts = Alert.all.count
		
		@server_time = Time.zone.now

		
		@in_time_zone = Time.zone.now.in_time_zone('Eastern Time (US & Canada)')
	end

	def about
	end
end
