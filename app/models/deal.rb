class Deal < ApplicationRecord
  belongs_to :user
  belongs_to :category
  belongs_to :store
  has_many :behaviors, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_attached_file :promoimage, styles: { big: "500x500", medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :promoimage, content_type: /\Aimage\/.*\z/
end
