class User < ApplicationRecord
	has_many :deals
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]	

    def self.from_omniauth(auth)
	  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
	  	if (auth.info.email != nil)
	    	user.email = auth.info.email
	  	else
	   		user.email = "novalid@facebook.com"
	  	end

	    user.password = Devise.friendly_token[0,20]
	  end
	end
		
	def mailboxer_email(object)
	  email
	end
end
