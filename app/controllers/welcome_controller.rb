class WelcomeController < ApplicationController
  def index
  	@hotvalue = Setting.find_by(core: 'hot_deal')
  	@topvalue = Setting.find_by(core: 'top_voted')
  	@hotvalue.present? ? @hot_deal = Deal.find(@hotvalue.value.to_i) : @hot_deal = Deal.where('status = 1').order('rank DESC').first
  	@topvalue.present? ? @top_voted = Deal.find(@topvalue.value.split(',')) : @top_voted = Deal.where('status = 1').order('rank DESC').limit(3)
    @deals = Deal.all.where('status = 1').order('created_at DESC').page(params[:page]).per(24)
  end
  def ayuda
  	@banners = Banner.order("RAND()").limit(3)
    @banners.each do |banner|
      banner.impressions = banner.impressions + 1
      banner.save
    end
  end
  def buenfin
   p @category_deal = Deal.joins(:category).limit(100)
  end
  def terminos
  	@banners = Banner.order("RAND()").limit(3)
    @banners.each do |banner|
      banner.impressions = banner.impressions + 1
      banner.save
    end
  end
  def nosotros
  	@banners = Banner.order("RAND()").limit(3)
    @banners.each do |banner|
      banner.impressions = banner.impressions + 1
      banner.save
    end
  end
end
