json.array!(@comics) do |comic|
  json.extract! comic, :id, :comic_id, :title, :issue, :description, :thumbnail
  json.url comic_url(comic, format: :json)
end
