class HomeController < ApplicationController

	def index
		@users = User.all.count
		@groups = Group.all.count	
		@events = Event.all.count
		@alerts = Alert.all.count
	end

	def about
	end
end
