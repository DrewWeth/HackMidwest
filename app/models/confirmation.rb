class Confirmation < ActiveRecord::Base
	
	belongs_to :event
	has_many :users

end
