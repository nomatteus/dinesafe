json.(establishment, :id,
                     :latest_type )
json.latest_name establishment.latest_name.present? ? establishment.latest_name.titleize : ""
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
  if show_infractions
    json.infractions inspection.infractions_by_severity do |json, infraction|
      json.(infraction, :id,
                        :details,
                        :action,
                        :court_outcome,
                        :amount_fined )
      json.severity infraction.severity_for_api
    end
  end
end
