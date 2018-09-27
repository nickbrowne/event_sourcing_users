json.extract! user, :id, :name, :description, :active, :visible, :created_at, :updated_at
json.url user_url(user, format: :json)
