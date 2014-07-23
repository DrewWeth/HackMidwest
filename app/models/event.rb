class Event < ActiveRecord::Base
	# active record
	belongs_to :group
	has_many :alerts	

	# validations
	validates :name, presence: true
	validates :start, presence: true
	validates :end, presence: true 
	# geocode
	geocoded_by :address
	after_validation :geocode, :if => :address_changed?
	
end
