class User < ActiveRecord::Base
  rolify
	rolify


	validates :phone_num, uniqueness: true
	validates :phone_num, numericality: { only_integer: true }
    validates :phone_num, length: { is: 10, message: "phone numbers must include area code and be 10 digits" }

    has_many :memberships
    has_many :groups, :through => :memberships
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
	 :recoverable, :rememberable, :trackable, :validatable

end
