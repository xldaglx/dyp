# This file is used by Rack-based servers to start the application.

require_relative 'config/environment'

if ENV['RACK_ENV'] == "production"
	use Rack::CanonicalHost, 'www.descuentosypromociones.com'
end

run Rails.application