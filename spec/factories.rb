FactoryGirl.define do
  factory :ups_cred, class: ActiveShipping::UPS do
  end

  factory :usps_cred, class: ActiveShipping::USPS do
  end
end
