class Banner < ApplicationRecord
	has_attached_file :image, styles: { original: "500x500" ,thumb: "250x250" }, :path => ":rails_root/public/banners/:filename", :url => "/banners/:filename",  default_url: "/banners/banner-no-photo.png"
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
end
