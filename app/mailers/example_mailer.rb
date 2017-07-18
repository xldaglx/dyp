class ExampleMailer < ApplicationMailer
  default :from => 'default@myapp.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Sample Email')
  end
end
