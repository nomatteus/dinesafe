json.data do
  json.partial! "establishment", establishment: @establishment, show_infractions: true
end
