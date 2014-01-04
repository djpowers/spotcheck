require 'spec_helper'

describe User do

  describe 'validation' do
    it { should have_valid(:name).when("Dave", "Dave Powers") }
    it { should_not have_valid(:name).when(nil, "") }

    it { should have_valid(:email).when("dave@videos.com", "david@video.co.uk") }
    it { should_not have_valid(:email).when(nil, "", "dave@") }

    it { should have_many :comments }
    it { should have_many :user_projects }
    it { should have_many(:projects).through(:user_projects) }
  end

  describe 'database' do
    it { should have_db_column(:name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:email).of_type(:string).with_options(null: false) }
  end

end
