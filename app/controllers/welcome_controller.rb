class WelcomeController < ApplicationController
  def index
    @deals = Deal.all
    @hot_deal = Deal.find(7)
    @top_voted = Deal.all
  end
end
