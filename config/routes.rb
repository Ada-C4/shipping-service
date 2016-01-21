Rails.application.routes.draw do
  get 'rates' => 'application#get_rates'
end
