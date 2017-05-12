class DealsController < ApplicationController
  before_action :set_deal, only: [:show, :edit, :update, :destroy]

  # GET /deals
  # GET /deals.json
  def index
    @deals = Deal.all
  end

  # GET /deals/1
  # GET /deals/1.json
  def show
  end

  # GET /deals/new
  def new
    @deal = Deal.new
  end

  # GET /deals/1/edit
  def edit
  end

  # POST /deals
  # POST /deals.json
  def create
    @deal = Deal.new(deal_params)
    @deal.user_id = current_user.id
    respond_to do |format|
      if @deal.save
        format.html { redirect_to @deal, notice: 'Deal was successfully created.' }
        format.json { render :show, status: :created, location: @deal }
      else
        format.html { render :new }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end
  def scrapp
    require 'nokogiri' #start by loading the nokogiri gem
    require 'open-uri' #this is required to open the URLs we are going to scrape
    require 'openssl'
    require 'watir'
    OpenSSL::SSL.const_set(:VERIFY_PEER, OpenSSL::SSL::VERIFY_NONE)    
    url = params['url_host']
    img_urls = Array.new
    #img_urls = Array.new #create an empty array to store the image urls in
    browser = Watir::Browser.new
    browser.goto url
    doc = Nokogiri::HTML.parse(browser.html)
    case url
    when /liverpool/
      p 'liverpool'
      img_urls = doc.css('.pzlcontainerviewer img').map{ |i| i['src'] }
    when /bestbuy/
      p 'bestbuy'
      image = doc.at("meta[name='twitter:image']")['content']
      img_urls.push(image)
    when /amazon/
      p 'Amazon'
      img_urls = doc.css('.imgTagWrapper img').map{ |i| i['src'] }
    when /elektra/
      p 'Elektra'
      img_urls = doc.css('.ccz-small').map{ |i| i['src'] }
    when /walmart/
      p 'Walmart'
      img_urls = doc.xpath('//meta[@property="og:image"]/@content').map(&:value)
    else
       img_urls = doc.xpath('//meta[@property="og:image"]/@content').map(&:value)
    end 

   respond_to do |format|
     format.html
     format.js {} 
     format.json { 
        render json: {:images => img_urls}
     } 
   end
    browser.close
  end
  # PATCH/PUT /deals/1
  # PATCH/PUT /deals/1.json
  def update
    respond_to do |format|
      if @deal.update(deal_params)
        format.html { redirect_to @deal, notice: 'Deal was successfully updated.' }
        format.json { render :show, status: :ok, location: @deal }
      else
        format.html { render :edit }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deals/1
  # DELETE /deals/1.json
  def destroy
    @deal.destroy
    respond_to do |format|
      format.html { redirect_to deals_url, notice: 'Deal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deal
      @deal = Deal.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def deal_params
      params.require(:deal).permit(:title, :description, :imagen, :link, :price, :expiration, :user_id, :type_deal, :promoimage)
    end
end
