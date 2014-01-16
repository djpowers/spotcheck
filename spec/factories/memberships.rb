FactoryGirl.define do
  factory :membership do
    user
    project
    role 'creator'
  end
end
