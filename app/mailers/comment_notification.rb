class CommentNotification < ActionMailer::Base
  default from: "do-not-reply@spotcheck.herokuapp.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.comment_notification.changes.subject
  #
  def changes(comment)
    @comment = comment

    mail to: [@comment.video.project.users.pluck(:email)],
      subject: 'New Comment on ' + @comment.video.project.title
  end
end
