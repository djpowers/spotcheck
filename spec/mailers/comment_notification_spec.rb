require "spec_helper"

describe CommentNotification do
  describe "changes" do

    it "renders the headers" do
      owner = FactoryGirl.create(:user)
      project = FactoryGirl.create(:project)
      Membership.create(user: owner, project: project)
      video = FactoryGirl.create(:video, project: project)
      comment = FactoryGirl.create(:comment, video: video)
      mail = CommentNotification.changes(comment)

      mail.subject.should eq('New Comment on ' + comment.video.project.title)
      mail.to.should eq(comment.video.project.users.pluck(:email))
      mail.from.should eq(["do-not-reply@spotcheck.herokuapp.com"])
    end

    it "renders the body" do
      owner = FactoryGirl.create(:user)
      project = FactoryGirl.create(:project)
      Membership.create(user: owner, project: project)
      video = FactoryGirl.create(:video, project: project)
      comment = FactoryGirl.create(:comment, video: video)
      mail = CommentNotification.changes(comment)

      mail.body.encoded.should match(project.title)
    end
  end

end
