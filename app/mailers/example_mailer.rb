class ExampleMailer < ApplicationMailer
  default :from => 'default@myapp.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Sample Email')
  end

  def reject_email(user)
    @user = user
    mail(to: @user.email, subject: 'Sample Email', :locals => { :message => 'Jane' })
  end
end
