class Deal < ApplicationRecord
  belongs_to :user
  has_many :categories
  has_many :behaviors
  has_many :comments
  has_attached_file :promoimage, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :promoimage, content_type: /\Aimage\/.*\z/
end
