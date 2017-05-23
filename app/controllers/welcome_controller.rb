class WelcomeController < ApplicationController
  def index
    @deals = Deal.all
    @hot_deal = Deal.find(5)
    @top_voted = Deal.all
  end
end
