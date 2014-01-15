require 'spec_helper'

describe Membership do

  before(:all) {  }

  describe 'validations' do
    it { should validate_presence_of :user }
    it { should validate_numericality_of :user_id }

    it { should validate_presence_of :project }
    it { should validate_numericality_of :project_id }

    it { should validate_presence_of :role }

    it { should belong_to :user }
    it { should belong_to :project}

    it do
      FactoryGirl.create(:membership)
      should validate_uniqueness_of(:project_id)
      .scoped_to(:user_id)
      .with_message('membership already exists.')
    end
  end

  describe 'database' do
    it { should have_db_column(:user_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:project_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:role).of_type(:string).with_options(null: false) }
  end

end
