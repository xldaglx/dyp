module UsersHelper
	def relationship(follower, followed)
		@relationship = Relationship.where('followed_id = '+ followed.to_s).where('follower_id = '+ follower.to_s)
		if @relationship.present?
			button = ""
			@relationship.each do |relationship|
				button = '<a class="btn-noseguir unfollow" href="#" idf="'+relationship.id.to_s+'"><i class="fa fa-bell-slash-o" aria-hidden="true"></i> Dejar de seguir</a>'
			end			
		else
			button = '<a class="btn-seguir follow" href="#" user_followed="'+followed.to_s+'"><i class="fa fa-bell-o" aria-hidden="true"></i> Seguir</a>'
		end
		return button.html_safe
	end
end
