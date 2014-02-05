require "spec_helper"

describe Inquiry do

  it 'renders the headers' do
    first_name = 'John'
    last_name = 'Doe'
    email = 'johndoe@mail.com'
    subject = 'Hello'
    body = 'Just wanted to say hi.'
    mail = Inquiry.inquiry_payload(first_name: first_name, last_name: last_name, email: email, subject: subject, body: body)

    mail.subject.should eq(subject)
    mail.to.should eq(['djpowers89@gmail.com'])
    mail.from.should eq([email])
  end

  it 'renders the body' do
    first_name = 'John'
    last_name = 'Doe'
    email = 'johndoe@mail.com'
    subject = 'Hello'
    body = 'Just wanted to say hi.'
    mail = Inquiry.inquiry_payload(first_name: first_name, last_name: last_name, email: email, subject: subject, body: body)

    mail.body.encoded.should match(body)
  end
end
