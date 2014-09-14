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

	def alert
		if session[:page_load] != nil then
		  session[:page_load] += 1
		else
		  session[:page_load] = 0
		end

		@queue_alerts = Alert.all.where(:is_sent => false)

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
			    the_event.over = true
			    the_event.save

			    the_group = Group.find(the_event.group_id)
			    
			    list_of_nums = the_group.users.where(restriction_level: 0)
			    
			    list_of_nums.each do |l|
			      mob_num = "+" + l.country.to_s + l.phone_num.to_s
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
  end
