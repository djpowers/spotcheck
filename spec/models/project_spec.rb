require 'spec_helper'

describe Project do

  describe 'validations' do
    it { should validate_presence_of :title }

    it { should have_many :videos }
    it { should have_many :user_projects }
    it { should have_many(:users).through(:user_projects) }
  end

  describe 'database' do
    it { should have_db_column(:title).of_type(:string).with_options(null: false) }
    it { should have_db_column(:description).of_type(:text) }
    it { should have_db_column(:status).of_type(:string) }
    it { should have_db_column(:due_date).of_type(:datetime) }
  end

end
