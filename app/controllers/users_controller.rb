class UsersController < ApplicationController
	before_action :require_permission
	def profile
		@account = User.find(params[:id])
	end

	def require_permission
		if current_user.id != User.find(params[:id]).id
		redirect_to root_path
		#Or do something else here
		end
	end
end