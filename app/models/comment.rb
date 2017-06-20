class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :deal
  has_many :likes
end
