class Group < ActiveRecord::Base
	has_many :users, :through => :memberships
	has_many :memberships
	
	has_many :events
end
