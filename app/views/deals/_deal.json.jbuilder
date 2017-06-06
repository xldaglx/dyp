json.extract! deal, :id, :title, :description, :imagen, :link, :price, :expiration, :user_id, :created_at, :updated_at
json.url deal_url(deal, format: :json)
