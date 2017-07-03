class UsersController < ApplicationController
	before_action :require_permission
	def profile
		@account = User.find(params[:id])
	end

	def deals
    	@deals = Deal.where('user_id',params[:id])  
	end

	def favorites
    	@deals = Deal.joins('LEFT JOIN favorites ON deals.id = favorites.deal_id').where('favorites.user_id = '+current_user.id.to_s)
	end

	def rated
		@deals = Deal.joins('LEFT JOIN behaviors ON deals.id = behaviors.deal_id').where('behaviors.user_id = '+current_user.id.to_s)
	end

	def require_permission
		if current_user.id != User.find(params[:id]).id
		redirect_to root_path
		#Or do something else here
		end
	end
end