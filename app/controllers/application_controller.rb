class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  require 'active_shipping'
  require 'ups'
  require 'usps'

end
