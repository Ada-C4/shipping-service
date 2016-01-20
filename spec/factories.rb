FactoryGirl.define do
  factory :shipping_params do
    username "foo"
    email { "#{username}@example.com" }
    password "foobar"
    password_confirmation "foobar"
  end


end
