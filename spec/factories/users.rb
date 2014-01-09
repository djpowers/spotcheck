FactoryGirl.define do
  factory :user do
    first_name 'Don'
    last_name 'Draper'
    sequence(:email) { |n| "person#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
    factory :user_with_project do
      after(:create) { |user| FactoryGirl.create(:membership, user: user) }
    end
  end
end
