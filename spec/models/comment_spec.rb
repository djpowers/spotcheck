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

  describe '#end_time_greater_than_start' do
    it 'rejects start times greater than end time' do
      comment = FactoryGirl.build(:comment, timecode_start: '00:00:04', timecode_end: '00:00:02')
      expect(comment.valid?).to eql(false)
    end
  end

  it 'sends a notification' do
    ActionMailer::Base.deliveries = []

    owner = FactoryGirl.create(:user)
    project = FactoryGirl.create(:project)
    Membership.create(user: owner, project: project)
    video = FactoryGirl.create(:video, project: project)
    FactoryGirl.build(:comment, video: video).revise

    expect(ActionMailer::Base.deliveries.size).to eql(1)
  end

end
