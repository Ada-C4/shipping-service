FactoryGirl.define do
  factory :merchant do
    user_name "Shonen Knife"
    email "shonen@knife.com"
    password "p"
    password_confirmation "p"
    city "University Place"
    state "WA"
    zip "98466"
    country "US"
  end

  factory :order do
    status "pending"
    order_time Time.now
    customer_name "Eileen"
    customer_email "Eileen@Eileen.com"
    street_address "555 France Street"
    zip_code 98467
    state "Washington"
    city "University Place"
    card_number 1234
    customer_card_exp_month 10
    customer_card_exp_year 2018
    security_code 123
    name_on_card "Eileen"
  end

  factory :order_item do
    product_id 1
    order_id 7
    quantity 1
    shipped false
  end

  factory :product do
    product_id 1
    category_id 1 

  end

end
