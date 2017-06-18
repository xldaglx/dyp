class Category < ApplicationRecord
	before_validation :generate_slug
	has_many :deals	
	
	def to_param
		"#{id}-#{name.parameterize}"
	end
	
	private
	def generate_slug
		self.slug = name.to_s.parameterize
	end
end
