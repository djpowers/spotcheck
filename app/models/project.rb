class Project < ActiveRecord::Base

  validates_presence_of :title

  has_many :videos
  has_many :user_projects
  has_many :users,
    through: :user_projects

end
