json.data @establishments do |json, establishment|
  json.partial! "establishment", establishment: establishment, show_infractions: false
end

json.paging do
  json.current_page @current_page
  json.total_pages @total_pages
end