module CommentsHelper
	def likeExists(commentid)
		like = Like.where('user_id='+current_user.id.to_s).where('comment_id='+commentid.to_s).first
		if like.present?
			html = '<div class="like liked" likeid="'+like.id.to_s+'" commentid="'+commentid.to_s+'" de="'+current_user.id.to_s+'" >Quitale el Like</div>'
			return html.html_safe
		else
			html = '<div class="like" commentid="'+commentid.to_s+'" de="'+current_user.id.to_s+'" >Dale Like</div>'
			return html.html_safe
		end
	end
end
