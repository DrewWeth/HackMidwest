class Event < ActiveRecord::Base
	# active record
	belongs_to :group
	has_many :alerts, dependent: :destroy 

	# validations
	validates :name, presence: true
	validates :start, presence: true
	validates :duration, presence: true 
	validates :address, presence: true 

	# geocode
	geocoded_by :address
	after_validation :geocode, :if => :address_changed?
	
end
