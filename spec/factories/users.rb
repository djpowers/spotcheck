FactoryGirl.define do
  factory :user do
    first_name 'Don'
    last_name 'Draper'
    sequence(:email) { |n| "person#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
  end
end
