class Event < ActiveRecord::Base
	belongs_to :group

	geocoded_by :address

	after_validation :geocode, :if => :address_changed?
	
end
