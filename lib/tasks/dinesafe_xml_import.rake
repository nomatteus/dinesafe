
namespace :dinesafe do 
  desc "Import/update data from dinesafe.xml file"
  task :xml_import => :environment do

    # TO DO : Add new Establishment model/table, so simplify queries

    doc = Nokogiri::XML(open(Rails.root.to_s + "/doc/dinesafe.xml"))
    #puts doc.xpath("/ROWDATA/ROW").inspect
    doc.xpath("//ROW").each do |row|
      id = row.xpath("ROW_ID").text.to_i

      # Create or Update Establishment
      establishment = Establishment.find_or_create_by_id( LEFT OFF HERE #......)
      # .. TO DO ..
      # 1. Move establishment info to separate table
      # 2. ...

      # Log inspection for Establishment
      inspection = Inspection.find_or_create_by_id(row.xpath("ROW_ID").text.to_i)
      inspection.update_attributes({
        :establishment_id              => row.xpath("ESTABLISHMENT_ID").text.to_i,
        :inspection_id                 => row.xpath("INSPECTION_ID").text.to_i,
        :establishment_name            => row.xpath("ESTABLISHMENT_NAME").text,
        :establishment_type            => row.xpath("ESTABLISHMENTTYPE").text,
        :establishment_address         => row.xpath("ESTABLISHMENT_ADDRESS").text,
        :establishment_status          => row.xpath("ESTABLISHMENT_STATUS").text,
        :minimum_inspections_per_year  => row.xpath("MINIMUM_INSPECTIONS_PERYEAR").text.to_i,
        :infraction_details            => row.xpath("INFRACTION_DETAILS").text,
        :inspection_date               => row.xpath("INSPECTION_DATE").text,
        :severity                      => row.xpath("SEVERITY").text,
        :action                        => row.xpath("ACTION").text,
        :court_outcome                 => row.xpath("COURT_OUTCOME").text,
        :amount_fined                  => row.xpath("AMOUNT_FINED").text.to_f
      })
      puts "Updated inspection row #{inspection.id}"
    end

  end
end