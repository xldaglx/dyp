module ApplicationHelper
	def resource_name
		:user
	end

	def resource
		@resource ||= User.new
	end

	def devise_mapping
		@devise_mapping ||= Devise.mappings[:user]
	end
	def rank_style(rank)
		case rank
			when 0
				return 'thumb-empty'
			when -100000..-1 then 'thumb-cold'
			when 1..60 then 'thumb-warm'
			when 61..100 then 'thumb-warmer'
		else
			'thumb-hot'
		end
	end
	def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false)
	     from_time = from_time.to_time if from_time.respond_to?(:to_time)
	     to_time = to_time.to_time if to_time.respond_to?(:to_time)
	     distance_in_minutes = (((to_time - from_time).abs)/60).round
	     distance_in_seconds = ((to_time - from_time).abs).round

	     case distance_in_minutes
	       when 0..1
	         return (distance_in_minutes == 0) ? 'un minuto' : '1 minuto' unless include_seconds
	         case distance_in_seconds
	           when 0..4   then '5 segundos'
	           when 5..9   then '10 segundos'
	           when 10..19 then '20 segundos'
	           when 20..59 then 'un minuto'
	         else             '1 minuto'
	         end

	        when 2..44           then "#{distance_in_minutes} minutos"
	        when 45..89          then '1 hora'
	        when 90..1439        then "#{(distance_in_minutes.to_f / 60.0).round} horas"
	        when 1440..2879      then '1 día'
	        when 2880..43199     then "#{(distance_in_minutes / 1440).round} días"
	        when 43200..86399    then '1 mes'
	        when 86400..525959   then "#{(distance_in_minutes / 43200).round} meses"
	        when 525960..1051919 then '1 año'
	     else                      "mas de #{(distance_in_minutes / 525960).round} años"

	   end
	end
end
