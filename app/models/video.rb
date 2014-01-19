class Video < ActiveRecord::Base

  validates_presence_of :video_file
  validates_numericality_of :revision_number

  validates_presence_of :project
  belongs_to :project

  has_many :comments

  mount_uploader :video_file, VideoFileUploader

end
