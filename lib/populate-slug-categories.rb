Category.all.each do |category|
	category.slug = category.description.to_s.parameterize
	category.save
end