json.array! @cities do |city|
  json.extract! city, :name, :photo, :payload
end
