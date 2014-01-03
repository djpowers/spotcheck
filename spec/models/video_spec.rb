require 'spec_helper'

describe Video do

  describe 'validation' do
    it { should validate_presence_of :title }
    it { should validate_numericality_of :revision_number }
    it { should validate_presence_of :approved }

    it { should validate_presence_of :project }
    it { should belong_to :project }
  end

  describe 'database' do
    it { should have_db_column(:title).of_type(:string).with_options(null: false) }
    it { should have_db_column(:revision_number).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:approved).of_type(:boolean).with_options(null: false, default: false) }
    it { should have_db_column(:project_id).of_type(:integer).with_options(null: false) }
  end

end
