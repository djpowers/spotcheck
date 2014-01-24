require 'spec_helper'

describe Project do

  describe 'validations' do
    it { should validate_presence_of :title }

    it { should have_many(:videos).dependent(:destroy) }
    it { should have_many(:memberships).dependent(:destroy) }
    it { should have_many(:users).through(:memberships) }
  end

  describe 'database' do
    it { should have_db_column(:title).of_type(:string).with_options(null: false) }
    it { should have_db_column(:description).of_type(:text) }
    it { should have_db_column(:status).of_type(:string) }
    it { should have_db_column(:due_date).of_type(:date) }
    it { should have_db_column(:due_time).of_type(:time) }
  end

  describe 'role checks' do
    let(:membership) { FactoryGirl.create(:membership) }
    let(:user) { membership.user }
    let(:project) { membership.project }

    it 'is a creator if the role is creator' do
      expect(project.is_creator?(user)).to be_true
      membership.role = 'collaborator'
      membership.save
      expect(project.is_creator?(user)).to_not be_true
    end

    it 'is a collaborator if the role is collaborator' do
      membership.role = 'collaborator'
      membership.save
      expect(project.is_collaborator?(user)).to be_true
    end

    it 'authorizes viewing of project' do
      expect(project.viewable_by?(user)).to be_true
      membership.role = 'collaborator'
      membership.save
      expect(project.viewable_by?(user)).to be_true
      membership.destroy
      expect(project.viewable_by?(user)).to be_false
    end
  end

end
