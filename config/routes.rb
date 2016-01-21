Rails.application.routes.draw do
  post 'rates' => 'application#get_rates'
end
