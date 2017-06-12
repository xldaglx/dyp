Store.all.each do |store|
	store.slug = store.description.to_s.parameterize
	store.save
end