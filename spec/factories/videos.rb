FactoryGirl.define do
  factory :video do
    video_file { File.open(File.join(Rails.root, '/spec/file_fixtures/valid_video.mp4')) }
    revision_number 1
    approved false
    project
  end
end
