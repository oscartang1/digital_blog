json.array!(@reviews) do |review|
  json.extract! review, :id, :product_id, :name, :review_text
  json.url review_url(review, format: :json)
end
