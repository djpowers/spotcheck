class Membership < ActiveRecord::Base

  validates_presence_of :user
  validates_numericality_of :user_id

  validates_presence_of :project
  validates_numericality_of :project_id

  validates_presence_of :role

  belongs_to :user
  belongs_to :project

end
