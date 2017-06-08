class WelcomeController < ApplicationController
  def index
    @deals = Deal.all.order('created_at DESC').page(params[:page]).per(9)
    @hot_deal = Deal.find(1)
    @top_voted = Deal.all
  end
end
