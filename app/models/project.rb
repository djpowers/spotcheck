class Project < ActiveRecord::Base

  extend FriendlyId
  friendly_id :title, use: :slugged

  validates_presence_of :title, :description

  has_many :videos,
    dependent: :destroy
  has_many :memberships,
    dependent: :destroy
  has_many :users,
    through: :memberships

  def creator
    users.resource(:memberships).where(memberships: {role: 'creator'} )
  end

  def is_creator?(user)
    memberships.where(user_id: user.id, role: 'creator').present?
  end

  def is_collaborator?(user)
    memberships.where(user_id: user.id, role: 'collaborator').present?
  end

  def viewable_by?(user)
    is_collaborator?(user) || is_creator?(user)
  end

end
