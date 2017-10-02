@users = User.all
@users.each do |user|
	totalrank = 0
	user.deals.where("created_at > ? AND created_at < ?", Time.now.beginning_of_month, Time.now.end_of_month).each do |deal|
		totalrank = totalrank + deal.rank
	end
	@userupdate = User.find(user.id)
	@userupdate.rank = totalrank
	@userupdate.save
end 