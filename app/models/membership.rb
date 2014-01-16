class Membership < ActiveRecord::Base

  validates_presence_of :user
  validates_presence_of :project
  validates_presence_of :role

  validates_uniqueness_of :project_id,
    scope: :user_id,
    message: 'Membership already exists.'

  belongs_to :user
  belongs_to :project

  attr_accessor :email

  def creator?
    role == 'creator'
  end

  def collaborator?
    role == 'collaborator'
  end
end
