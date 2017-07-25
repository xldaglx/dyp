class MessageMailer < ActionMailer::Base

  default from: "Your Mailer <noreply@promocionesydescuentos.com>"
  default to: "Your Name <gerardoayalad@outlook.com>"

  def new_message(message)
    @message = message
    
    mail subject: "Message from #{message.name}"
  end

end

