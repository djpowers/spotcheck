class User < ActiveRecord::Base

  validates_presence_of :name
  validates_email_format_of :email

  has_many :comments
  has_many :user_projects
  has_many :projects,
    through: :user_projects

end
