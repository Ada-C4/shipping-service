FactoryGirl.define do

  factory :origin do
    country "US"
    state "CA"
    city "San Francisco"
    postal_code "94132"
  end

  factory :destination do
    country "US"
    state "WA"
    city "Seattle"
    postal_code "98161"
  end

end
