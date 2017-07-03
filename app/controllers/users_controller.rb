class UsersController < ApplicationController
	def profile
		@account = User.find(current_user)
		@promoHot = User.joins(:deals).where('deals.rank > 1').where('deals.user_id', current_user.id).count
	end

	def deals
    	@deals = Deal.where('user_id ='+params[:id])
		@promoHot = User.joins(:deals).where('deals.rank > 1').where('deals.user_id ='+current_user.id.to_s).count
	end

	def favorites
    	@deals = Deal.joins('LEFT JOIN favorites ON deals.id = favorites.deal_id').where('favorites.user_id = '+current_user.id.to_s)
		@promoHot = User.joins(:deals).where('deals.rank > 1').where('deals.user_id ='+current_user.id.to_s).count
	end

	def ranking
    	
	end

	def rated
		@deals = Deal.joins('LEFT JOIN behaviors ON deals.id = behaviors.deal_id').where('behaviors.user_id = '+current_user.id.to_s)
		@promoHot = User.joins(:deals).where('deals.rank > 1').where('deals.user_id ='+current_user.id.to_s).count
	end
	
	def publicprofile
    	@deals = Deal.where('user_id = '+params[:id])
    	@user = User.find(params[:id])
		@promoHot = User.joins(:deals).where('deals.rank > 1').where('deals.user_id ='+params[:id].to_s).count
	end

end