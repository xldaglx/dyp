class User < ApplicationRecord
	has_many :deals
	has_many :behaviors
	has_many :comments
  	has_many :favorites
  	has_many :relationships, foreign_key: "followed_id", :dependent => :destroy
	has_attached_file :avatar, styles: { desktop: "200x200#" ,mobile: "150x150#" }, :path => ":rails_root/public/images/users/:style/:filename", :url => "/images/users/:style/:filename",  default_url: "/images/:style/user-no-photo.png"
	validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\z/
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
