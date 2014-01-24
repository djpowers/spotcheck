require 'spec_helper'

describe Comment do

  describe 'validation' do
    it { should validate_presence_of :body }

    it { should have_valid(:timecode_start).when('01:23:45', nil, '') }
    it { should_not have_valid(:timecode_start).when('012345') }

    it { should have_valid(:timecode_end).when('01:23:45', nil, '') }
    it { should_not have_valid(:timecode_end).when('012345') }

    it { should validate_presence_of :user }
    it { should belong_to :user }

    it { should validate_presence_of :video }
    it { should belong_to :video }
  end

  describe 'database' do
    it { should have_db_column(:body).of_type(:text).with_options(null: false) }
    it { should have_db_column(:timecode_start).of_type(:string) }
    it { should have_db_column(:timecode_end).of_type(:string) }
    it { should have_db_column(:user_id).of_type(:integer).with_options(null: false) }
    it { should have_db_column(:video_id).of_type(:integer).with_options(null: false) }
  end

  describe '#time_in_seconds' do
    it 'returns the converted timecode in seconds' do
      comment = FactoryGirl.create(:comment, timecode_start: '00:01:12', timecode_end: '00:01:20')
      expect(comment.start_in_seconds).to eql(72)
      expect(comment.end_in_seconds).to eql(80)
    end
  end

end
