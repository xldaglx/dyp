class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  	def after_sign_in_path_for(resource)
  		'/mi-cuenta/mis-descuentos/'+current_user.id.to_s
	end
	def after_sign_up_path_for(resource)
  		'/mi-cuenta/mis-descuentos/'+current_user.id.to_s
	end
end
