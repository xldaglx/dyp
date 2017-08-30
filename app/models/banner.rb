class Banner < ApplicationRecord
	has_attached_file :image, styles: { original: "500x500" ,thumb: "250x250" }, :path => ":rails_root/public/banners/:filename", :url => "/banners/:filename",  default_url: "/banners/banner-no-photo.png"
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
end

=begin
class Banner < ApplicationRecord
	has_attached_file :image, styles: { original: "500x500" ,thumb: "250x250" }, 
	:path => ":rails_root/public/banners/:file_name", 
	:url => "/banners/:file_name",  default_url: "/banners/banner-no-photo.png"
	#:path => ":rails_root/public/banners/:normalized_file_name", 
	#:url => "/banners/:normalized_file_name",  default_url: "/banners/banner-no-photo.png"
	validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  #Paperclip.interpolates :normalized_file_name do |attachment, style|
  #  attachment.instance.normalized_file_name
  #end

  #def normalized_file_name
  #  "#{self.id}-#{self.image_file_name.gsub( /[^a-zA-Z0-9_\.]/, '_')}"
  #end
=end