class DealsController < ApplicationController
  before_action :set_deal, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:moderate]

  # GET /deals
  # GET /deals.json
  def amazonapi
  #!/usr/bin/env ruby


secret = "nfBx5nt3Rv+vzeKj21/Eqxa/sSLpfhZhgBcrZZhq"
endpoint = "webservices.amazon.com.mx"
request_uri = "/onca/xml"
params = {
  "Service" => "AWSECommerceService",
  "Operation" => "ItemLookup",
  "AWSAccessKeyId" => "AKIAIDZTT3WCPPLJPAUA",
  "AssociateTag" => "1083f5-20",
  "ItemId" => "B00YEZQ5L0",
  "IdType" => "ASIN",
  "ResponseGroup" => "Images,ItemAttributes,Offers,Reviews"
}
# Set current timestamp if not set
params["Timestamp"] = Time.now.gmtime.iso8601 if !params.key?("Timestamp")

# Generate the canonical query
canonical_query_string = params.sort.collect do |key, value|
  [URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")), URI.escape(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))].join('=')
end.join('&')

# Generate the string to be signed
string_to_sign = "GET\n#{endpoint}\n#{request_uri}\n#{canonical_query_string}"

# Generate the signature required by the Product Advertising API
signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), secret, string_to_sign)).strip()

# Generate the signed URL
request_url = "http://#{endpoint}#{request_uri}?#{canonical_query_string}&Signature=#{URI.escape(signature, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}"

result = HTTParty.get(request_url)
#p page = Nokogiri::HTML(page)

# Convert the String response into a plain old Ruby array. It is faster and saves you time compared to the standard Ruby libraries too.
#result = JSON.parse(buffer)

# An example of how to take a random sample of elements from an array. Pass the number of elements you want into .sample() method. It's probably a better idea for the server to limit the results before sending, but you can use basic Ruby skills to trim & modify the data however you'd like.
#result = result.sample(1)

# Loop through each of the elements in the 'result' Array & print some of their attributes.

   respond_to do |format|
       format.html
       format.js {} 
       format.xml { 
          render xml: {:xml => result}
      } 
   end  

  end

  def index
    @deals = Deal.all  
  end
  def dealhit
    @deal = Deal.find(params[:dealid])
    if @deal.hits.nil?
      @deal.hits = 0
    end
    @deal.hits += 1
    @deal.save
    respond_to do |format|
       format.html
       format.js {} 
       format.json { 
          render json: {:message => 'success'}
      } 
    end

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
        @deals = Deal.all.page(params[:page]).where('status = 1').order('created_at DESC').per(24)
      else   
        @deals = Deal.all.where("type_deal = "+ params['filter-promo']).where('status = 1').page(params[:page]).order('created_at DESC').per(24)
      end
    else
      @deals = Deal.all.page(params[:page]).where('status = 1').order('created_at DESC').per(24)
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
        @deals = Deal.all.page(params[:page]).where('status = 1').where("created_at > ?", Time.now-15.days).order('impressions DESC').per(24)
      else   
        @deals = Deal.all.where("type_deal = "+ params['filter-promo']).where('status = 1').where("created_at > ?", Time.now-15.days).page(params[:page]).order('impressions DESC').per(24)
      end
    else
      @deals = Deal.all.page(params[:page]).where('status = 1').where("created_at > ?", Time.now-15.days).order('impressions DESC').per(24)
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
      @deals = Deal.where('status = '+params[:status]).page(params[:page]).order('created_at DESC').page(params[:page]).per(24)
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
    @related = Deal.where('category_id ='+ @deal.category.id.to_s).where('id !='+id[0]).where('created_at >= ?', 1.week.ago).order("RAND()").limit(3)
    if current_user.try(:admin?)

    else
      @banners.each do |banner|
        banner.impressions = banner.impressions + 1
        banner.save
      end
      if @deal.impressions.nil?
        @deal.impressions = 0
      end
      @deal.impressions += 1
      @deal.save
    end
    if @deal.mpn.present?
      secret = "nfBx5nt3Rv+vzeKj21/Eqxa/sSLpfhZhgBcrZZhq"
      endpoint = "webservices.amazon.com.mx"
      request_uri = "/onca/xml"
      params = {
        "Service" => "AWSECommerceService",
        "Operation" => "ItemLookup",
        "AWSAccessKeyId" => "AKIAIDZTT3WCPPLJPAUA",
        "AssociateTag" => "1083f5-20",
        "ItemId" => @deal.mpn,
        "IdType" => "ASIN",
        "ResponseGroup" => "ItemAttributes,Offers,Reviews"
      }

      params["Timestamp"] = Time.now.gmtime.iso8601 if !params.key?("Timestamp")
      canonical_query_string = params.sort.collect do |key, value|
        [URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")), URI.escape(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))].join('=')
      end.join('&')
      string_to_sign = "GET\n#{endpoint}\n#{request_uri}\n#{canonical_query_string}"
      signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), secret, string_to_sign)).strip()
      request_url = "http://#{endpoint}#{request_uri}?#{canonical_query_string}&Signature=#{URI.escape(signature, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}"
      result = HTTParty.get(request_url)
      data = result.parsed_response
      p my_string = data.to_s
      if my_string.include? "Errors"
         
      else
          if my_string.include? "DetailPageURL"
          @newurl = data['ItemLookupResponse']['Items']['Item']['DetailPageURL']
          end
          if my_string.include? "\"HasReviews\"=>\"true\""
          @iframeurl = data['ItemLookupResponse']['Items']['Item']['CustomerReviews']['IFrameURL']
          end
          if my_string.include? "LowestNewPrice"
          price =  data['ItemLookupResponse']['Items']['Item']['OfferSummary']['LowestNewPrice']['Amount']
          price = price[0...-2]
          pricepadividir = @deal.price.to_f
          dividir = (price.to_f/pricepadividir) - 1
          @price = price
          @pricevariant = dividir * 100
        end
      end
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
            render json: {:message => 'exists', :deals => @deals}
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

  case url
  when /amazon/

  amazon_url = url
  if amazon_url.match(/\/dp\/(\w{10})(\/|\Z)/)
      asin = $1
  elsif amazon_url.match(/\/gp\/\w*?\/(\w{10})(\/|\Z)/)
      asin = $1
  elsif amazon_url.match(/\/gp\/\w*?\/(\w{10})(\?th=*)/)
      asin = $1
  elsif amazon_url.match(/\/gp\/\w*?\/(\w{10})(\?psc=*)/)
      asin = $1
  elsif amazon_url.match(/\/gp\/\w*?\/\w*?\/(\w{10})(\/|\Z)/)
      asin = $1
  elsif amazon_url.match(/\/gp\/[\w-]*?\/(\w{10})(\/|\Z)/)
      asin = $1
  elsif amazon_url.match(/\/product-reviews\/(\w{10})(\/|\Z)/)
      asin = $1
  elsif amazon_url.match(/[?&]asin=(\w{10})(&|#|\Z)/i)
      asin = $1
  else
      asin = false
  end
  secret = "nfBx5nt3Rv+vzeKj21/Eqxa/sSLpfhZhgBcrZZhq"
  endpoint = "webservices.amazon.com.mx"
  request_uri = "/onca/xml"
  params = {
    "Service" => "AWSECommerceService",
    "Operation" => "ItemLookup",
    "AWSAccessKeyId" => "AKIAIDZTT3WCPPLJPAUA",
    "AssociateTag" => "1083f5-20",
    "ItemId" => asin,
    "IdType" => "ASIN",
    "ResponseGroup" => "Images,ItemAttributes,Offers"
  }

  params["Timestamp"] = Time.now.gmtime.iso8601 if !params.key?("Timestamp")
  canonical_query_string = params.sort.collect do |key, value|
    [URI.escape(key.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]")), URI.escape(value.to_s, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))].join('=')
  end.join('&')
  string_to_sign = "GET\n#{endpoint}\n#{request_uri}\n#{canonical_query_string}"
  signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest.new('sha256'), secret, string_to_sign)).strip()
  request_url = "http://#{endpoint}#{request_uri}?#{canonical_query_string}&Signature=#{URI.escape(signature, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}"
  result = HTTParty.get(request_url)
  data = result.parsed_response
  model =  data['ItemLookupResponse']#['Items']['Item']['ASIN']
  img_urls.push (data['ItemLookupResponse']['Items']['Item']['LargeImage']['URL'])
  my_string = data.to_s
  if my_string.include? "Errors"
     
  else
    if my_string.include? "LowestNewPrice"
      price =  data['ItemLookupResponse']['Items']['Item']['OfferSummary']['LowestNewPrice']['Amount']
      price = price[0...-2]
    end
    if my_string.include? "OfferListing"
      price =  data['ItemLookupResponse']['Items']['Item']['Offers']['Offer']['OfferListing']['Price']['Amount']
      price = price[0...-2]
    end
  end
  title =  data['ItemLookupResponse']['Items']['Item']['ItemAttributes']['Title']
  when /liverpool/
    page = HTTParty.get(url)
    page = Nokogiri::HTML(page)
    #p page
    title = page.xpath("//meta[@property='og:title']/@content").text
    img_urls.push page.xpath("//input[@id='jsonImageMap']/@value").text
    price = page.xpath("//input[@id='maximumPromoPrice']/@value").text
    store = "liverpool" 
  when /walmart/
    page = HTTParty.get(url)
    page = Nokogiri::HTML(page)
    store = "walmart"
    page.xpath("//meta[@property='og:image']/@content").each do |img|
      img_urls.push (img.text)
    end
    title = page.xpath("//meta[@property='og:title']/@content").text
  when /chedraui/
    page = HTTParty.get(url)
    page = Nokogiri::HTML(page)
    store = "chedraui"
    page.xpath('//img').each do |img|
      img_urls.push (img['src'])
    end
    title = page.at_css('title').text
  when /bestbuy/
    page = HTTParty.get(url)
    page = Nokogiri::HTML(page)
    store ="bestbuy"
    title = page.at_css('title').text
    img_urls.push page.xpath("//meta[@property='og:image']/@content").text
    page.xpath('//img').each do |img|
      img_urls.push (img['src'])
    end
    price = page.xpath("//span[@itemprop='price']").text
    if price.blank?
     price = page.at_css('.pb-purchase-price').text
    end
  when /palacio/
    page = HTTParty.get(url)
    page = Nokogiri::HTML(page)
    store ="palaciodehierro"
    title = page.at_css('title').text
    page.xpath('//img').each do |img|
    img_urls.push (img['src'])
    end
    price = page.xpath("//span[@class='price']").text
  when /costco/
    page = HTTParty.get(url)
    page = Nokogiri::HTML(page)
    store="costco"
    title = page.at_css('title').text
    page.xpath('//img').each do |img|
    img_urls.push ("http://www.costco.com.mx"+img['src'])
    end
    price = page.xpath("//div[@id='inclprice']").text
  when /adidas/
    page = HTTParty.get(url)
    page = Nokogiri::HTML(page)
    store="adidas"
    title = page.at_css('title').text
    img_urls.push page.xpath("//meta[@property='og:image']/@content").text
    price = page.xpath("//span[@itemprop='price']").text
  when /linio/
    page = HTTParty.get(url)
    page = Nokogiri::HTML(page)
    #Lazy loading is messing with scrapping
    title = page.xpath("//meta[@property='og:title']/@content").text
    img_urls.push page.xpath("//meta[@property='og:image']/@content").text
    price = page.xpath("//meta[@itemprop='price']/@content").text
  when /radioshack/
    page = HTTParty.get(url)
    page = Nokogiri::HTML(page)
    #Lazy loading is messing with scrapping
    title = page.xpath("//meta[@name='twitter:title']/@content").text
    imageurl =  page.xpath("//meta[@name='twitter:image']/@content").text
    img_urls.push imageurl
    store = "radioshack"
  when /officedepot/
    page = HTTParty.get(url)
    page = Nokogiri::HTML(page)
    title = page.at_css('title').text
    imageurl = "https://www.officedepot.com.mx"+page.xpath("//img[@itemprop='image']/@src")[0].text
    img_urls.push imageurl
    price = page.xpath("//div[@id='priceData']").text
    store = "officedepot"
  when /elektra/
    page = HTTParty.get(url)
    page = Nokogiri::HTML(page)
    title = page.at_css('title').text
    img_urls.push (page.xpath("//meta[@itemprop='image']/@content").text)
    price = page.xpath("//meta[@itemprop='price']/@content").text
    store = "elektra"
  when /homestore/
    page = HTTParty.get(url)
    page = Nokogiri::HTML(page)
    title = page.at_css('title').text
    price = page.at_css('.PricesalesPrice').text
  when /homedepot/
    page = HTTParty.get(url)
    page = Nokogiri::HTML(page)
    title = page.at_css('title').text
    price = page.xpath("//div[@itemprop='price']/@content").text
  when /sanborns/
    page = HTTParty.get(url)
    page = Nokogiri::HTML(page)
    title = page.at_css('title').text
    img_urls.push page.xpath("//meta[@name='og:image']/@content").text
  else
    page = HTTParty.get(url)
    page = Nokogiri::HTML(page)
    title = page.at_css('title').page.text
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
      format.html { redirect_to "/moderate", notice: 'Deal was successfully destroyed.' }
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
      params.require(:deal).permit(:title, :description, :imagen, :link, :price, :expiration, :user_id, :type_deal, :promoimage, :category_id , :store_id ,:status, :rank,:mpn,:impressions, :hits)
    end
    def admin_user
     if current_user.try(:admin?)
       flash.now[:success] = "Admin Access Granted"
      else
       redirect_to root_path
      end
    end
end
