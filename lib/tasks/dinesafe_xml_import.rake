require 'open-uri'

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
      inspection = Inspection.find_or_create_by_establishment_id_and_inspection_date_and_infraction_details(establishment.id, row.xpath("INSPECTION_DATE").text)
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
      pct = i.to_f / total_rows.to_f * 100
      #puts "Updated inspection ID: #{inspection.id}              #{pct}% done"   
      print "#{reset}Importing from XML: #{pct}%"
      i += 1
    end
  end

  desc "Geocodes 1000 records at a time (but only if record is not geocoded already)"
  task :geocode => :environment do
    1000.times do 
      # Get new record to geocode
      e = Establishment.where("geocoding_results_json IS NULL").first
      puts e.id
      address = e.address.gsub " ", "+" #Replace spaces with '+' to make URL-safe
      map_url = "http://maps.googleapis.com/maps/api/geocode/json?address=#{address},+toronto,+on&sensor=false"
      puts "Map url is: #{map_url}"
      geo_json_raw = open(map_url).read
      geo_json_parsed = ActiveSupport::JSON.decode(geo_json_raw)
      if geo_json_parsed["status"] == "OK"
        e.geocoding_results_json = geo_json_raw
        e.lat = BigDecimal.new(geo_json_parsed["results"][0]["geometry"]["location"]["lat"], 10)
        e.lng = BigDecimal.new(geo_json_parsed["results"][0]["geometry"]["location"]["lng"], 10)
        geo_json_parsed["results"][0]["address_components"].each do |comp|
          comp["types"].each do |type|
            if type == "postal_code"
              e.postal_code = comp["long_name"]
            end
          end
        end
        e.save
      else
        puts geo_json_raw.inspect
        puts "RESULT STATUS IS **NOT OK** Status returned is: #{geo_json["status"]}"
        puts "sleeping for 10 seconds"
        sleep 10
      end
      sleep_how_long = [1,2,3,4,5,6,7,8,9,11,17,23,33].sample
      puts "sleeping #{sleep_how_long} sec....."
      sleep sleep_how_long
      puts 'and go again! (or, this might be the last time)'
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
