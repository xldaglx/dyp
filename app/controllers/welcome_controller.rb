class WelcomeController < ApplicationController
  def index
    @deals = Deal.all.order('created_at DESC').page(params[:page]).per(3)
    @hot_deal = Deal.find(10)
    @top_voted = Deal.all
  end
end
