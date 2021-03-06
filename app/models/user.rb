class User < ActiveRecord::Base
  rolify

	validates :phone_num, uniqueness: true
	validates :phone_num, numericality: { only_integer: true }



    has_many :memberships
    has_many :groups, :through => :memberships
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	 :recoverable, :rememberable, :trackable, :validatable

end
