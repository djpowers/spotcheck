require 'spec_helper'

describe User do

  let(:blanks){ [nil, ''] }

  describe 'validation' do
    it { should have_valid(:first_name).when("Dave", "Jean Luc") }
    it { should_not have_valid(:first_name).when(*blanks) }

    it { should have_valid(:last_name).when("Powers", "Goddard") }
    it { should_not have_valid(:last_name).when(*blanks) }

    it 'has a matching password confirmation for the password' do
      user = User.new
      user.password = 'password'
      user.password_confirmation = 'anotherpassword'

      expect(user).to_not be_valid
      expect(user.errors[:password_confirmation]).to_not be_blank
    end

    it { should have_many :comments }
    it { should have_many :user_projects }
    it { should have_many(:projects).through(:user_projects) }
  end

  describe 'database' do
    it { should have_db_column(:first_name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:last_name).of_type(:string).with_options(null: false) }
    it { should have_db_column(:email).of_type(:string).with_options(null: false) }
  end

end
