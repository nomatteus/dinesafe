# NOTE: Used to use partial but that doubled the time to render. This is very similar to code in show.json.jbuilder
# TODO: Use .to_json instead to make it even more faster (still takes ~150ms to render) and DRY it up.
json.data @establishments do |json, establishment|
  json.(establishment, :id,
                       :latest_type )
  json.latest_name establishment.name
  json.address establishment.address.present? ? establishment.address.titleize : ""
  json.latlng establishment.latlng_dict
  json.distance establishment.distance.to_f if establishment[:distance].present?
  json.inspections establishment.inspections do |json, inspection|
    json.(inspection, :id,
                      :status,
                      :date,
                      :minimum_inspections_per_year,
                      :establishment_type )
    json.establishment_name inspection.establishment_name.present? ? inspection.establishment_name.titleize : ""
  end
  json.share do
    json.text_short establishment.share_text_short
    json.text_long establishment.share_text_long
    json.text_long_html establishment.share_text_long_html
    json.url establishment.share_url
  end
end

json.paging do
  json.current_page @current_page
  json.total_pages @total_pages
end