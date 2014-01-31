class Comment < ActiveRecord::Base

  validates_presence_of :body

  # ensure valid timecode format is entered (if provided)
  validates_format_of :timecode_start, { with: /0?\d:[0-5][0-9]:[0-5][0-9]/, allow_blank: true }
  validates_format_of :timecode_end, { with: /0?\d:[0-5][0-9]:[0-5][0-9]/, allow_blank: true }

  validates_presence_of :user
  belongs_to :user

  validates_presence_of :video
  belongs_to :video

  validate :end_time_greater_than_start, if: :both_times_present?

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

  def end_time_greater_than_start
    unless time_in_seconds(timecode_end) > time_in_seconds(timecode_start)
      errors[:timecode_end] << 'must be greater than timecode start'
    end
  end

  def revise
    if save
      CommentNotification.changes(self).deliver
      return true
    else
      return false
    end
  end

  private

    def both_times_present?
      timecode_start.present? && timecode_end.present?
    end

end
