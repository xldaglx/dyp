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
  end
end
#SitemapGenerator::Sitemap.ping_search_engines # Not needed if you use the rake tasks