Rails.application.routes.draw do
  post '/ups_rates', to: 'shipping#ups_rates'
  post '/usps_rates', to: 'shipping#usps_rates'
end
