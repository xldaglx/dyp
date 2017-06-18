class Store < ApplicationRecord
	before_validation :generate_slug
	has_many :deals
	has_attached_file :logo, styles: { big: "500x500", medium: "300x300>", small: "150x150>" ,thumb: "100x100>" }, :path => ":rails_root/public/images/store/:style/:filename", :url => "/images/store/:style/:filename",  default_url: "/images/:style/missing.png"
	validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/
	
	def to_param
		"#{id}-#{name.parameterize}"
	end
	
	private
	def generate_slug
		self.slug = name.to_s.parameterize
	end
end
