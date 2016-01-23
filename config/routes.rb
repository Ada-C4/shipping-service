Rails.application.routes.draw do
  root to: "shipments#shipment"
  get 'shipments/quote' => 'shipments#shipment'

end
