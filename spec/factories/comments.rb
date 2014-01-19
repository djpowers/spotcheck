FactoryGirl.define do
  factory :comment do
    body 'Please edit title color to blue.'
    timecode_start '00:01:00:00'
    timecode_end '00:01:05:00'
    user
    video
  end
end
