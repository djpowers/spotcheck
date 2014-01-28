class Comment < ActiveRecord::Base

  validates_presence_of :body

  # ensure valid timecode format is entered (if provided)
  validates_format_of :timecode_start, { with: /0?\d:[0-5][0-9]:[0-5][0-9]/, allow_blank: true }
  validates_format_of :timecode_end, { with: /0?\d:[0-5][0-9]:[0-5][0-9]/, allow_blank: true }

  validates_presence_of :user
  belongs_to :user

  validates_presence_of :video
  belongs_to :video

  def time_in_seconds(tc)
    hours, minutes, seconds = tc.split(':')
    (hours.to_i * 3600) + (minutes.to_i * 60) + (seconds.to_i)
  end

  def start_in_seconds
    time_in_seconds(timecode_start)
  end

  def end_in_seconds
    time_in_seconds(timecode_end)
  end

  def revise
    if save
      CommentNotification.changes(self).deliver
      return true
    else
      return false
    end
  end

end
