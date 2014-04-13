json.array!(@entities) do |entity|
  json.extract! entity, :id, :title
  json.url entity_url(entity, format: :json)
end
