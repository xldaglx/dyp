class WelcomeController < ApplicationController
  def index
    @deals = Deal.all
    @hot_deal = Deal.find(1)
    @top_voted = Deal.all
  end
end
