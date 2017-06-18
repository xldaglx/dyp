class Deal < ApplicationRecord
	before_validation :generate_slug
	belongs_to :user, optional: true
	belongs_to :category
	belongs_to :store
	has_many :behaviors, :dependent => :destroy
	has_many :comments, :dependent => :destroy
	has_attached_file :promoimage, styles: { big: "500x500", medium: "300x300>", small: "150x150>" ,thumb: "100x100>" }, :path => ":rails_root/public/images/deals/:style/:filename", :url => "/images/deals/:style/:filename",  default_url: "/images/:style/missing.png"
	validates_attachment_content_type :promoimage, content_type: /\Aimage\/.*\z/
		
	def to_param
		"#{id}-#{title.parameterize}"
	end
	
	private
	def generate_slug
		self.slug = title.to_s.parameterize
	end

	def self.search(search)
	  where("title LIKE ?", "%#{search}%") 
	  where("description LIKE ?", "%#{search}%") 
	end
end
