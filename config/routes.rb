Rails.application.routes.draw do
  get 'ups' => 'application#ups_get_rates'
end
