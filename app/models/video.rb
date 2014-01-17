class Video < ActiveRecord::Base

  validates_presence_of :resource
  validates_numericality_of :revision_number

  validates_presence_of :project
  belongs_to :project

end
