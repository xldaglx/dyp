Deal.all.each do |deal|
	deal.slug = deal.title.to_s.parameterize
	deal.save
end