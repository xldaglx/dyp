require 'rubygems'
require 'nokogiri'   
require 'open-uri'
require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
PAGE_URL = "https://www.amazon.com.mx/gp/product/B01BG1O71E/ref=s9u_simh_gw_i2?ie=UTF8&pd_rd_i=B01BG1O71E&pd_rd_r=T7A93C8YRA1E1Y5NZN81&pd_rd_w=RwSvf&pd_rd_wg=GqSoq&pf_rd_m=AVDBXBAVVSXLQ&pf_rd_s=&pf_rd_r=NRSNYGDRAX3BESSGEJPG&pf_rd_t=36701&pf_rd_p=fe19d36a-3411-4bce-8ef7-fef09d37fff8&pf_rd_i=desktop"
page = Nokogiri::HTML(open(PAGE_URL))
puts page.css("title")[0].name   # => title
puts page.css("title")[0].text   # => My webpage
