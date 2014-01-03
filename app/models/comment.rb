class Comment < ActiveRecord::Base

  validates_presence_of :body

  # ensure valid timecode format is entered (if provided)
  validates_format_of :timecode_start, { with: /0?\d:[0-5][0-9]:[0-5][0-9]:\d{2}/, allow_blank: true }
  validates_format_of :timecode_end, { with: /0?\d:[0-5][0-9]:[0-5][0-9]:\d{2}/, allow_blank: true }

  validates_presence_of :user
  belongs_to :user

  validates_presence_of :video
  belongs_to :video

end
