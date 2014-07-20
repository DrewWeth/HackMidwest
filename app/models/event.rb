class Event < ActiveRecord::Base
	belongs_to :group
	has_many :alerts	

	geocoded_by :address

	after_validation :geocode, :if => :address_changed?
	
end
