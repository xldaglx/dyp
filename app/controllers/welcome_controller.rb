class WelcomeController < ApplicationController
  def index
    @deals = Deal.all.where('status = 1').order('created_at DESC').page(params[:page])
    @hot_deal = Deal.where('status = 1').order('rank DESC').first
    @top_voted = Deal.where('status = 1').order('rank DESC')
  end
end
