class UsersController < ApplicationController
    before_action :authenticate_user!, only: [:deals, :rated, :favorites, :ranking, :followers]
	def followers
		@users = Relationship.select('users.*, relationships.*').joins('LEFT JOIN users ON relationships.follower_id = users.id').where('relationships.followed_id='+current_user.id.to_s)
		@promoHot = User.joins(:deals).where('deals.rank > 1').where('deals.user_id ='+current_user.id.to_s).count
	end
	def followed
		@users = Relationship.select('users.*, relationships.*').joins('LEFT JOIN users ON relationships.followed_id = users.id').where('relationships.follower_id='+current_user.id.to_s)
		@promoHot = User.joins(:deals).where('deals.rank > 1').where('deals.user_id ='+current_user.id.to_s).count
	end

	def deals
    	@deals = Deal.where('user_id ='+current_user.id.to_s).order('deals.id DESC').page(params[:page]).per(24)
		@promoHot = User.joins(:deals).where('deals.rank > 1').where('deals.user_id ='+current_user.id.to_s).count
	end

	def favorites
    	@deals = Deal.joins('LEFT JOIN favorites ON deals.id = favorites.deal_id').where('favorites.user_id = '+current_user.id.to_s).order('deals.id DESC').page(params[:page]).per(24)
		@promoHot = User.joins(:deals).where('deals.rank > 1').where('deals.user_id ='+current_user.id.to_s).count
	end

	def ranking
		@users = User.all.order('rank DESC').limit(10)
		@promoHot = User.joins(:deals).where('deals.rank > 1').where('deals.user_id ='+current_user.id.to_s).count
	end

	def rated
		@deals = Deal.joins('LEFT JOIN behaviors ON deals.id = behaviors.deal_id').where('behaviors.user_id = '+current_user.id.to_s).order('deals.id DESC').page(params[:page]).per(24)
		@promoHot = User.joins(:deals).where('deals.rank > 1').where('deals.user_id ='+current_user.id.to_s).count
	end
	def adminusers
		@users = User.all.page(params[:page]).per(24)
	end
	def follow
		@relationships = Relationship.new
		@relationships.follower_id = params[:follower]
		@relationships.followed_id = params[:followed]
		if @relationships.save
			respond_to do |format|
         	format.html
         	format.js {} 
         	format.json { 
            	render json: {:message => 'success'}
        	} 
      		end
      	else
			respond_to do |format|
         	format.html
         	format.js {} 
         	format.json { 
            	render json: {:message => 'error'}
        	} 
      		end      		
      	end
	end

	def unfollow
		@relationship = Relationship.find(params[:follow])
		if @relationship.destroy
			respond_to do |format|
	     	format.html
	     	format.js {} 
	     	format.json { 
	        	render json: {:message => 'success'}
	    	} 
	  		end     
		else
			respond_to do |format|
	     	format.html
	     	format.js {} 
	     	format.json { 
	        	render json: {:message => 'error'}
	    	} 
	  		end     
		end
	end

	def cranking
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
	end
	
	def publicprofile
    	@deals = Deal.where('user_id = '+params[:id])
    	@user = User.find(params[:id])
		@promoHot = User.joins(:deals).where('deals.rank > 1').where('deals.user_id ='+params[:id].to_s).count
	end

end