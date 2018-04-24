class Deal < ApplicationRecord
	before_validation :generate_slug
	belongs_to :user, optional: true
	belongs_to :category
	belongs_to :store
  	has_many :favorites, :dependent => :destroy
	has_many :behaviors, :dependent => :destroy
	has_many :comments, :dependent => :destroy
	#has_attached_file :promoimage, styles: { big: "500x500", medium: "300x300>", small: "150x150>" ,thumb: "100x100>" }, :path => ":rails_root/public/images/deals/:style/:filename", :url => "/images/deals/:style/:filename",  default_url: "/images/:style/missing.png"
	has_attached_file :promoimage, 
                :styles => { big: "500x500", medium: "300x300>", small: "150x150>" ,thumb: "100x100>"},
                :storage => :fog,
				:fog_credentials => { :google_storage_access_key_id => 'GOOG5J32USKGQQSURB22',
				                 :google_storage_secret_access_key => 'KecNrdPTnKW6FYbIDRPnWwQv6bnCwyXxQHjzgFsP',
				                 :provider => 'Google' },
                :fog_directory => "descuentosypromociones",
                :path => ":rails_root/public/images/deals/:style/:filename",
                :url => "/images/deals/:style/:filename",
                :default_url => "/images/:style/missing.png"
	validates_attachment_content_type :promoimage, content_type: /\Aimage\/.*\z/
		
	def to_param
		"#{id}-#{title.parameterize}"
	end
	
	private
	def generate_slug
		self.slug = title.to_s.parameterize
	end

	def self.search(search)
	  where("title LIKE '%#{search}%' OR description LIKE '%#{search}%'").order('created_at DESC').limit(48)
	end

  	def self.getData
      @deals = Deal.where('crawler = 1');
      @deals.each do |deal|
        require 'open-uri'
        price = ""
        url_primary = deal.link
        url_liverpool = deal.liverpool
        url_walmart = deal.walmart
        url_elektra = deal.elektra
        url_amazon = deal.amazon
        url_bestbuy = deal.bestbuy
		if deal.bestbuy.present?
		  page = HTTParty.get(deal.bestbuy)
		  page = Nokogiri::HTML(page)
		  inline_script = page.xpath('//script[contains(text(), "INITIAL_PAGE_STATE")]')
		  inline = inline_script.to_s.partition('window.INITIAL_PAGE_STATE').last
		  inline = inline.to_s.partition('window.liveConfig').first
		  inline = inline.delete('\\"')
		  inline = inline.delete('\\"')
		  inline = inline.delete('\\')
		  inline = inline.delete('}')
		  inline = inline.delete('{')
		  inline = inline.split(",")
		  inline.each do |ind|
		    if ind.include? "customerPrice"
		       price = ind.to_s.partition(':').last
		    end
		  end
		  @pricing = Price.new(Deal_id: deal.id, store: "Best Buy", price: price)
		  @pricing.save
		end
       if deal.amazon.present?
          page = HTTParty.get(deal.amazon)
          page = Nokogiri::HTML(page)
          price = page.xpath("//span[@id='priceblock_ourprice']").text 
          price = price.gsub(/\W/, ' ')
          price = price.gsub(/[^0-9,.]/, "")
          price = price[0...-2]
          @pricing = Price.new(Deal_id: deal.id, store: "Amazon", price: price)
          @pricing.save
        end

        if deal.liverpool.present?
          page = HTTParty.get(deal.liverpool)
          page = Nokogiri::HTML(page)
          price = page.xpath("//input[@id='minimumPromoPrice']/@value").text 
          @pricing = Price.new(Deal_id: deal.id, store: "Liverpool", price: price)
          @pricing.save
        end

        if deal.walmart.present?
          page = HTTParty.get(deal.walmart)
          page = Nokogiri::HTML(page)
          page = page.xpath('//script[contains(text(), "price")]')
          page = page.to_s.partition('price').last
          page = page.gsub(/\W/, ' ')
          page = page.gsub(/[^0-9,.]/, "")
          price = page[0...-2]
          @pricing = Price.new(Deal_id: deal.id, store: "Walmart", price: price)
          @pricing.save
        end

        if deal.elektra.present?
          page = HTTParty.get(deal.elektra)
          page = Nokogiri::HTML(page)
          price = page.at("//meta[@itemprop='price']")['content']
          @pricing = Price.new(Deal_id: deal.id, store: "Elektra", price: price)
          @pricing.save
        end
    end
  	end
end
