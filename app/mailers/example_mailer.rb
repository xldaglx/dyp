class ExampleMailer < ApplicationMailer
  default :from => 'default@descuentosypromociones.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Bienvenido! Empieza a comprar inteligente')
  end

  def reject_email(user)
    @user = user
    mail(to: @user.email, subject: 'Promoción rechazada')
  end
end
