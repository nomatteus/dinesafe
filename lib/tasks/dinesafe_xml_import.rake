
namespace :dinesafe do 
  desc "Import/update data from dinesafe.xml file"
  task :xml_import => :environment do

    # For progress indicator -- from http://snippets.dzone.com/posts/show/3760
    # move cursor to beginning of line
    cr = "\r"           
    # ANSI escape code to clear line from cursor to end of line
    # "\e" is an alternative to "\033"
    # cf. http://en.wikipedia.org/wiki/ANSI_escape_code
    clear = "\e[0K"     
    # reset lines
    reset = cr + clear



    doc = Nokogiri::XML(open(Rails.root.to_s + "/doc/dinesafe.xml"))
    #puts doc.xpath("/ROWDATA/ROW").inspect
    rows = doc.xpath("//ROW")
    total_rows = rows.length
    i = 0
    rows.each do |row|
      # Note: It appears ROW_ID will not always refer to the same establishment/restaurant
      #       Instead, we might have to use the Inspection ID as unique key
      #       So, don't rely on/use ROW_ID at all!
      #id = row.xpath("ROW_ID").text.to_i

      # Create or Update Establishment
      establishment = Establishment.find_or_create_by_id(row.xpath("ESTABLISHMENT_ID").text.to_i)
      current_name = establishment.name
      current_est_type = establishment.est_type
      current_address = establishment.address
      establishment.update_attributes({
        :name       => row.xpath("ESTABLISHMENT_NAME").text,
        :est_type   => row.xpath("ESTABLISHMENTTYPE").text,
        :address    => row.xpath("ESTABLISHMENT_ADDRESS").text
      })
      if current_name != establishment.name
        puts "Change detected! Old: #{current_name} New: #{establishment.name}" 
      end
      if current_est_type != establishment.est_type
        puts "Change detected! Old: #{current_est_type} New: #{establishment.est_type}" 
      end
      if current_address != establishment.address
        puts "Change detected! Old: #{current_address} New: #{establishment.address}" 
      end
      #puts "Updated establishment ID: #{establishment.id}"

      # Log inspection for Establishment
      inspection = Inspection.find_or_create_by_establishment_id_and_inspection_date(establishment.id, row.xpath("INSPECTION_DATE").text)
      inspection.update_attributes({
        :establishment_id              => establishment.id,
        :establishment_status          => row.xpath("ESTABLISHMENT_STATUS").text,
        :minimum_inspections_per_year  => row.xpath("MINIMUM_INSPECTIONS_PERYEAR").text.to_i,
        :infraction_details            => row.xpath("INFRACTION_DETAILS").text,
        :inspection_date               => row.xpath("INSPECTION_DATE").text,
        :severity                      => row.xpath("SEVERITY").text,
        :action                        => row.xpath("ACTION").text,
        :court_outcome                 => row.xpath("COURT_OUTCOME").text,
        :amount_fined                  => row.xpath("AMOUNT_FINED").text.to_f
      })
      # Must be an easier way to do this -- pct. with 2 decimal places
      pct = i / total_rows
      #puts "Updated inspection ID: #{inspection.id}              #{pct}% done"   
      print "#{reset}Importing from XML: #{pct}%"
      i += 1
    end
  end

  desc "Generates JSON object with Inspection info, so we don't have to query the inspections table each time"
  task :generate_inspection_json => :environment do
    Establishment.find(:all).each do |e|
    #Establishment.first(2).each do |e| # for testing
      inspections = Inspection.where(:establishment_id => e.id).order(:inspection_date)
      e.inspections_json = inspections.to_json
      e.save
      puts "Updated establishment ID: #{e.id}"
    end
  end
end