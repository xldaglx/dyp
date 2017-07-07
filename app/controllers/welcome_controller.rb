class WelcomeController < ApplicationController
  def index
    @deals = Deal.all.order('created_at DESC').page(params[:page])
    @hot_deal = Deal.order('rank DESC').first
    @top_voted = Deal.all
  end
end
