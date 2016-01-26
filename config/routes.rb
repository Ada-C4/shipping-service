Rails.application.routes.draw do
  post 'estimate' => 'shipments#estimate'
end
