class WelcomeController < ApplicationController
  def index
  	@hotvalue = Setting.find_by(core: 'hot_deal');
  	@topvalue = Setting.find_by(core: 'top_voted');
  	p Deal.find(@topvalue.value.split(','))
  	@hotvalue.present? ? @hot_deal = Deal.find(@hotvalue.value.to_i) : @hot_deal = Deal.where('status = 1').order('rank DESC').first
  	@topvalue.present? ? @top_voted = Deal.find(@topvalue.value.split(',')) : @top_voted = Deal.where('status = 1').order('rank DESC')
    @deals = Deal.all.where('status = 1').order('created_at DESC').page(params[:page])
  end
end
