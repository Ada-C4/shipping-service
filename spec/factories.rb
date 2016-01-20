FactoryGirl.define do
  factory :estimate do
    price 100
    carrier "UPS"
    service_name "ground"
    shipment
  end

  factory :location do
    country "US"
    city "Seattle"
    state "WA"
    zip 98105
  end

  factory :package do
    dimensions "[4, 5, 6]"
    weight 456
    shipment
  end

  factory :shipment do
  end
end
