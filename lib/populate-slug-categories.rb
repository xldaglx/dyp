Category.all.each do |category|
	category.slug = category.description.to_s.parameterize
	category.name = category.description.to_s
	category.save
end