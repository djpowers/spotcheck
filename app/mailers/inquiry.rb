class Inquiry < ActionMailer::Base
  default from: "do-no-reply@spotcheck.herokuapp.com"

  def inquiry_payload(params)
    @first_name = params[:inquiry][:first_name]
    @last_name = params[:inquiry][:last_name]
    @email = params[:inquiry][:email]
    @subject = params[:inquiry][:subject]
    @body = params[:inquiry][:body]

    mail to: 'djpowers89@gmail.com',
      subject: @subject,
      from: @email
  end
end
