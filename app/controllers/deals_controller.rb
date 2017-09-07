class DealsController < ApplicationController
  before_action :set_deal, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:moderate]

  # GET /deals
  # GET /deals.json
  def index
    @deals = Deal.all  
  end

  def stores
    if params['filter-promo'].present?
      if params['filter-promo'] == "all"
        @deals = Deal.where("store_id = "+params[:id]).where('status = 1').page(params[:page]).order('created_at DESC')
      else   
        @deals = Deal.where("store_id = "+params[:id]).where('status = 1').where("type_deal = "+ params['filter-promo']).page(params[:page]).order('created_at DESC')
      end
    else
      @deals = Deal.where("store_id = "+params[:id]).where('status = 1').page(params[:page]).order('created_at DESC')
    end
    @tienda = Store.find(params[:id])
  end

  def categories
    if params['filter-promo'].present?
      if params['filter-promo'] == "all"
        @deals = Deal.where("category_id = "+params[:id]).where('status = 1').page(params[:page]).order('created_at DESC')
      else   
        @deals = Deal.where("category_id = "+params[:id]).where('status = 1').where("type_deal = "+ params['filter-promo']).page(params[:page]).order('created_at DESC')
      end
    else
      @deals = Deal.where("category_id = "+params[:id]).where('status = 1').page(params[:page]).order('created_at DESC')
    end
    @category = Category.find(params[:id])
  end

  def newdeals
    if params['filter-promo'].present?
      if params['filter-promo'] == "all"
        @deals = Deal.all.page(params[:page]).where('status = 1').order('created_at DESC')
      else   
        @deals = Deal.all.where("type_deal = "+ params['filter-promo']).where('status = 1').page(params[:page]).order('created_at DESC')
      end
    else
      @deals = Deal.all.page(params[:page]).where('status = 1').order('created_at DESC')
    end 
  end

  def search
    if params['filter-promo'].present?
      if params['filter-promo'] == "all"
        @deals = Deal.all.page(params[:page]).where('status = 1').order('created_at DESC')
      else   
        @deals = Deal.all.where("type_deal = "+ params['filter-promo']).where('status = 1').page(params[:page]).order('created_at DESC')
      end
    else
      @deals = Deal.all.page(params[:page]).where('status = 1').order('created_at DESC')
    end 
    @deals = @deals.search(params[:search]).where('status = 1') if params[:search].present?
  end

  def topdeals
    if params['filter-promo'].present?
      if params['filter-promo'] == "all"
        @deals = Deal.all.page(params[:page]).where('status = 1').where("created_at > ?", Time.now-15.days).order('rank DESC')
      else   
        @deals = Deal.all.where("type_deal = "+ params['filter-promo']).where('status = 1').where("created_at > ?", Time.now-15.days).page(params[:page]).order('rank DESC')
      end
    else
      @deals = Deal.all.page(params[:page]).where('status = 1').where("created_at > ?", Time.now-15.days).order('rank DESC')
    end 
  end
  def updateStatus
    id = params[:id]
    iddeal = params[:iddeal]
    notify = params[:notify]
    if id == "accept"
      @deal = Deal.find(iddeal)
      @deal.status = 1
    else 
      if id == "reject"
        @deal = Deal.find(iddeal)
        if @deal.user_id.present?
          if notify == 1
            ExampleMailer.reject_email(@deal.user).deliver
          end
        end
        @deal.status = 2
        reason = params[:reason]
      else
        id = "error"
      end
    end
    if @deal.save  
      respond_to do |format|
         format.html
         format.js {} 
         format.json { 
            render json: {:message => id}
        } 
      end
    else
      format.html { render :show }
      format.json { render json: @deal.errors, status: :unprocessable_entity }

    end

  end

  def moderate
    if params[:status].present?
      @deals = Deal.where('status = '+params[:status]).page(params[:page]).order('created_at DESC')
    else
      @deals = Deal.all.page(params[:page]).order('created_at DESC')
    end
      @deals0 = Deal.where('status = 0').count
      @deals1 = Deal.where('status = 1').count
      @deals2 = Deal.where('status = 2').count
      @deals3 = Deal.all.count
  end

  # GET /deals/1
  # GET /deals/1.json
  def show
    id = params[:id].split('-')
    @report = Report.where('deal_id ='+id[0])
    @banners = Banner.order("RAND()").limit(3)
    @banners.each do |banner|
      banner.impressions = banner.impressions + 1
      banner.save
    end
  end

  # GET /deals/new
  def new
    @deal = Deal.new
    @categories = Category.all
    @stores = Store.all
  end

  # GET /deals/1/edit
  def edit
    @categories = Category.all
    @stores = Store.all
  end

  # POST /deals
  # POST /deals.json
  def create
    @deal = Deal.new(deal_params)
    @deal.user_id = nil
    if user_signed_in?
      @deal.user_id = current_user.id
    end
    @deal.status = 0
    @deal.rank = 0
    respond_to do |format|
      if @deal.save
        format.html { redirect_to root_path, notice: 'Tu promoción ha sido enviada, la revisaremos y la publicaremos tan pronto como sea posible.' }
        format.json { render :show, status: :created, location: @deal }
      else
        format.html { render :new }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end
  def rank
    promoid = params['promoid']
    @deal =  Deal.find(promoid)
    number = params['number']
    if number == "positive"
      number = "1"
      @deal.rank = @deal.rank.to_i + 1
    else
      number = "0"
      @deal.rank = @deal.rank.to_i - 1
    end
    @deal.save
    userid = 1
    if user_signed_in?
      userid = current_user.id
    end
    @behavior = Behavior.all.where('user_id = '+userid.to_s).where('deal_id ='+promoid.to_s)
    if @behavior.exists?
      respond_to do |format|
         format.html
         format.js {} 
         format.json { 
            render json: {:message => 'error'}
        } 
      end
    else
    @behavior = Behavior.new(grade: number, user_id: userid, deal_id: promoid)
    @behavior.save
      respond_to do |format|
         format.html
         format.js {} 
         format.json { 
            render json: {:message => 'success', :rank => @deal.rank, :number => number}
        } 
      end
    end
  end
  def validatelink
    url_host = params['url_host'].to_s;
    @deals = Deal.all.where('link LIKE "%'+url_host+'%"')
    if @deals.exists?
      respond_to do |format|
         format.html
         format.js {} 
         format.json { 
            render json: {:message => 'exists'}
        } 
      end
    else
      respond_to do |format|
         format.html
         format.js {} 
         format.json { 
            render json: {:message => 'error'}
        }       
      end
    end
  end
  def scrapp
    price = ""
    model = ""
    title = ""
    store = ""
    img_urls = Array.new
    url = params['url_host']
    require 'open-uri'
begin

  page = HTTParty.get(url)
  page = Nokogiri::HTML(page)

  case url
  when /amazon/
    title = page.css("title")[0].text
    price = page.xpath("//span[@id='priceblock_ourprice']").text
    price_special = page.xpath("//span[@id='priceblock_dealprice']").text
    price_salesprice = page.xpath("//span[@id='priceblock_saleprice']").text
    if price_special != ""
      price = price_special
    end
    if price_salesprice != ""
      price = price_salesprice
    end
    model = page.xpath("//input[@id='ASIN']/@value").map(&:value)
    page.xpath('//img').each do |img|
      img_urls.push (img['src'])
    end
  when /liverpool/
    #p page
    title = page.xpath("//meta[@property='og:title']/@content").text
    img_urls.push page.xpath("//input[@id='jsonImageMap']/@value").text
    price = page.xpath("//input[@id='maximumPromoPrice']/@value").text
    store = "liverpool"
    
  when /walmart/
    store = "walmart"
    page.xpath("//meta[@property='og:image']/@content").each do |img|
      img_urls.push (img.text)
    end
    title = page.xpath("//meta[@property='og:title']/@content").text

  when /chedraui/
    store = "chedraui"
    page.xpath('//img').each do |img|
      img_urls.push (img['src'])
    end
    title = page.at_css('title').text

  when /bestbuy/
    store ="bestbuy"
    title = page.at_css('title').text
    img_urls.push page.xpath("//meta[@property='og:image']/@content").text
    price = page.xpath("//span[@itemprop='price']").text

  when /palacio/
    store ="palaciodehierro"
    title = page.at_css('title').text
    page.xpath('//img').each do |img|
    img_urls.push (img['src'])
    end
    price = page.xpath("//span[@class='price']").text

  when /costco/
    store="costco"
    title = page.at_css('title').text
    page.xpath('//img').each do |img|
    img_urls.push ("http://www.costco.com.mx"+img['src'])
    end
    price = page.xpath("//div[@id='inclprice']").text
  when /adidas/
    store="adidas"
    title = page.at_css('title').text
    img_urls.push page.xpath("//meta[@property='og:image']/@content").text
    p price = page.xpath("//span[@itemprop='price']").text
  when /linio/
    #Lazy loading is messing with scrapping
    title = page.xpath("//meta[@property='og:title']/@content").text
    img_urls.push page.xpath("//meta[@property='og:image']/@content").text
    p price = page.xpath("//meta[@itemprop='price']/@content").text
  else
    title = page.at_css('title').text
    page.xpath('//img').each do |img|
    img_urls.push (img['src'])
    end
  end

  respond_to do |format|
   format.html
   format.js {}   
   format.json { 
      render json: {:images => img_urls, :title => title, :price => price, :url => url, :model => model, :store => store}
   } 
  end
      
rescue Exception => e
   respond_to do |format|
     format.html
     format.js {}   
     format.json { 
        render json: {:message => "error"}
     } 
   end
end
end  
def scrapromotion
  
end
def scrapromotionajax
    img_urls = Array.new
    url = params['url_host']
    require 'open-uri'

begin
    page = Nokogiri::HTML(open(url))
    title = page.css("title")[0].text


  respond_to do |format|
   format.html
   format.js {}   
   format.json { 
      render json: {:images => img_urls, :title => title}
   } 
  end
      
rescue Exception => e
   respond_to do |format|
     format.html
     format.js {}   
     format.json { 
        render json: {:message => "error"}
     } 
   end
end
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
  def generateSitemap
    require 'rubygems'
    require 'sitemap_generator'

    SitemapGenerator::Sitemap.default_host = 'http://www.descuentosypromociones.com'
    SitemapGenerator::Sitemap.create do
      add '/', :changefreq => 'daily', :priority => 1
      add '/nosotros', :changefreq => 'weekly', :priority => 0.9
      add '/contact', :changefreq => 'weekly', :priority => 0.9
      add '/ayuda', :changefreq => 'weekly', :priority => 0.9
      add '/terminos', :changefreq => 'weekly', :priority => 0.9
      add '/todas-las-categorias', :changefreq => 'weekly', :priority => 0.9
      add '/todas-las-tiendas', :changefreq => 'weekly', :priority => 0.9
      @deals = Deal.all
      @deals.each do |content|
        add "/descuentos/"+content.id.to_s+"-"+content.slug.to_s+"", :lastmod => content.updated_at, :priority => 0.8
        p "/descuentos/"+content.id.to_s+"-"+content.slug.to_s+""
      end
    end
    #SitemapGenerator::Sitemap.ping_search_engines # Not needed if you use the rake tasks
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
      params.require(:deal).permit(:title, :description, :imagen, :link, :price, :expiration, :user_id, :type_deal, :promoimage, :category_id , :store_id ,:status, :rank,:mpn)
    end
    def admin_user
     if current_user.try(:admin?)
       flash.now[:success] = "Admin Access Granted"
      else
       redirect_to root_path
      end
    end
end
