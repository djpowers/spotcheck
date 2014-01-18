FactoryGirl.define do
  factory :video do
    video_file 'http://example.com'
    revision_number 1
    approved false
    project
  end
end
