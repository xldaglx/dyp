class MessagesController < ApplicationController

  def new
    @message = Message.new
    @banners = Banner.all
  end

  def create
    @banners = Banner.all
    @message = Message.new(message_params)
    
    if @message.valid?
      MessageMailer.new_message(@message).deliver
      redirect_to contact_path, notice: "Mensaje enviado"
    else
      flash[:alert] = "Error, revisa los campos e intenta de nuevo"
      render :new
    end
  end

private

  def message_params
    params.require(:message).permit(:name, :email, :content)
  end

end