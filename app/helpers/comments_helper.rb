module CommentsHelper
	def likeExists(commentid)
		if user_signed_in?
			like = Like.where('user_id='+current_user.id.to_s).where('comment_id='+commentid.to_s).first
			if like.present?
				html = '<div class="like liked rojo" likeid="'+like.id.to_s+'" commentid="'+commentid.to_s+'" de="'+current_user.id.to_s+'" ><i class="fa fa-thumbs-down" aria-hidden="true"></i> Ya no me gusta</div>'
				return html.html_safe
			else
				html = '<div class="like" commentid="'+commentid.to_s+'" de="'+current_user.id.to_s+'" > <i class="fa fa-thumbs-up" aria-hidden="true"></i> Me gusta </div>'
				return html.html_safe
			end
		else
			html = "<div class='like2'>Me gusta</div>"
			return html.html_safe
		end
	end
	def getParent(commentid)
		@comment = Comment.find(commentid)
		if @comment.present?
			html = '<div class="parent_comment"><span class="glyphicon glyphicon-pencil"></span> Respuesta a:'+@comment.description+'</div>'
			return html.html_safe
		else
			html = 'No extra comments'
			return html.html_safe
		end
	end
end
