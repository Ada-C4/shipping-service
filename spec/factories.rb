FactoryGirl.define do

  factory :shipping_params do
    association :destination
    association :package
  end

  factory :origin do
    country "US"
    state "CA"
    city "San Francisco"
    postal_code "94132"
    association :package
  end

  factory :destination do
    country "US"
    state "WA"
    city "Seattle"
    postal_code "98161"
  end

  factory :package do
    association :origin
    association :package_item
  end

  factory :package_item do
    weight "10" # grams
    height "15" # cm
    length "15" # cm
    width "15" # cm
    association :package
  end

end
