class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :first_name
  validates_presence_of :last_name

  has_many :comments
  has_many :memberships
  has_many :projects,
    through: :memberships

  def created_projects
    projects.joins(:memberships).where("memberships.role = 'creator'")
  end

end
