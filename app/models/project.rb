class Project < ActiveRecord::Base

  validates_presence_of :title

  has_many :videos
  has_many :memberships
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
