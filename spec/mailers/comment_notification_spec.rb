require "spec_helper"

describe CommentNotification do
  describe "changes" do
    let(:mail) { CommentNotification.changes }

    it "renders the headers" do
      mail.subject.should eq("Changes")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
