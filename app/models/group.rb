class Group < ActiveRecord::Base
	has_many :users, :through => :memberships
	has_many :memberships
	

	has_many :events, dependent: :destroy 

	validates :name, presence: true 

end

