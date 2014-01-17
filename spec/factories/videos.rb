FactoryGirl.define do
  factory :video do
    resource 'http://example.com'
    revision_number 1
    approved false
    project
  end
end
