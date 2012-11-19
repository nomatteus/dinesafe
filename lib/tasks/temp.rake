
namespace :temptasks do

  desc "Create Infractions from inspections (after running migration to create table)"
  task :nov17 => :environment do
    Inspection.find_each do |inspection|
      if inspection.infraction_details.present? or 
        inspection.severity.present? or inspection.action.present? or 
        inspection.court_outcome.present? or inspection.amount_fined > 0
        Infraction.create(
          :inspection => inspection,
          :details => inspection.infraction_details,
          :severity => inspection.severity,
          :action => inspection.action,
          :court_outcome => inspection.court_outcome,
          :amount_fined => inspection.amount_fined,
        )
      end
    end
  end

  desc "Move geocodes to their own table"
  task :nov17geo => :environment do
    Establishment.find_each do |establishment|
      g = Geocode.find_or_create_by_address(establishment.address)
      g.update_attributes({
        :address => establishment.address,
        :postal_code => establishment.postal_code,
        :latlng => establishment.latlng,
        :geocoding_results_json => establishment.geocoding_results_json
      })
    end
  end

end