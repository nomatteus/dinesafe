require 'open-uri'

namespace :dinesafe do 
  desc "Download and extract latest dinesafe.xml file"
  task :update_xml => :environment do 
    file_url = "http://opendata.toronto.ca/public.health/dinesafe/dinesafe.zip"
    # TODO: Sometimes the xml filename isn't "dinesafe.xml" (was "dinesafe2011.xml" once),
    #       so should adapt script to work with any .xml filename within the zip.
    dinesafe_xml_file = Rails.root.to_s + "/doc/dinesafe.xml"
    dinesafe_xml_temp_file = Rails.root.to_s + "/doc/DELETE_OLD_dinesafe.xml"
    dinesafe_zip_temp_path = Rails.root.to_s + "/doc/tmp_dinesafe.zip"
    dinesafe_zip_folder = Rails.root.to_s + "/doc"

    # Move current dinesafe.xml to temporary file
    if File.exist? dinesafe_xml_file
      FileUtils.mv(dinesafe_xml_file, dinesafe_xml_temp_file)
    end
    # Download latest
    open(dinesafe_zip_temp_path, "wb") do |file|
      file << open(file_url).read
    end
    # Use shell to unzip zip file
    `unzip #{dinesafe_zip_temp_path} -d #{dinesafe_zip_folder}`
    # If dinesafe.xml exists, assume extraction worked and remove old xml and zip file
    if File.exist? dinesafe_xml_file
      File.delete(dinesafe_zip_temp_path) if File.exist? dinesafe_zip_temp_path
      File.delete(dinesafe_xml_temp_file) if File.exist? dinesafe_xml_temp_file
    end
  end

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
      # current_name = establishment.name
      # current_est_type = establishment.est_type
      current_address = establishment.address
      establishment.update_attributes({
        :latest_name    => row.xpath("ESTABLISHMENT_NAME").text,
        :latest_type    => row.xpath("ESTABLISHMENTTYPE").text,
        :address        => row.xpath("ESTABLISHMENT_ADDRESS").text,
      })
      # if current_name != establishment.name
      #   puts "Change detected! Old: #{current_name} New: #{establishment.name}" 
      # end
      # if current_est_type != establishment.est_type
      #   puts "Change detected! Old: #{current_est_type} New: #{establishment.est_type}" 
      # end
      if current_address != establishment.address
        puts "Change detected! Old: #{current_address} New: #{establishment.address}" 
      end
      #puts "Updated establishment ID: #{establishment.id}"

      # Log inspection for Establishment
      Rails.logger.info establishment.id.to_s
      Rails.logger.info row.xpath("INSPECTION_DATE").text
      Rails.logger.info row.xpath("INFRACTION_DETAILS").text
      # The assumption here is that all inspections on the same date
      #  will have the same establishment status and min inspections.
      #  From what I've seen in the data, this is the case, and it makes sense.
      inspection = Inspection.find_or_create_by_id(row.xpath("INSPECTION_ID").text.to_i)
      inspection.update_attributes({
        :establishment_id              => establishment.id,
        :establishment_name            => row.xpath("ESTABLISHMENT_NAME").text.strip,
        :establishment_type            => row.xpath("ESTABLISHMENTTYPE").text.strip,
        :status                        => row.xpath("ESTABLISHMENT_STATUS").text.strip,
        :minimum_inspections_per_year  => row.xpath("MINIMUM_INSPECTIONS_PERYEAR").text.to_i,
        :date                          => row.xpath("INSPECTION_DATE").text.strip,
      })
      # Create each infraction if there is one.
      infraction_attributes = {
        :inspection_id      => inspection.id,
        :details            => row.xpath("INFRACTION_DETAILS").text.strip, # ** infraction
        :severity           => row.xpath("SEVERITY").text.strip, # ** infraction
        :action             => row.xpath("ACTION").text.strip, # ** infraction
        :court_outcome      => row.xpath("COURT_OUTCOME").text.strip, # ** infraction
        :amount_fined       => row.xpath("AMOUNT_FINED").text.to_f # ** infraction
      }
      if (infraction_attributes[:details].present? or 
        infraction_attributes[:severity].present? or 
        infraction_attributes[:action].present? or 
        infraction_attributes[:court_outcome].present? or 
        infraction_attributes[:amount_fined] > 0)
          # This combination of attributes should always be unique
          infraction = Infraction.find_or_create_by_inspection_id_and_severity_and_details_and_amount_fined(
            infraction_attributes[:inspection_id],
            infraction_attributes[:severity],
            infraction_attributes[:details],
            infraction_attributes[:amount_fined],
          )
          infraction.update_attributes(infraction_attributes)
      end
      # Must be an easier way to do this -- pct. with 2 decimal places
      pct = i.to_f / total_rows.to_f * 100
      #puts "Updated inspection ID: #{inspection.id}              #{pct}% done"   
      print "#{reset}Importing from XML: #{pct}%"
      i += 1
    end
  end

  desc "Update latlng establishments (uses geocode table, so update geocode info first)"
  task :update_latlngs => :environment do
    Establishment.where("latlng IS NULL").each do |establishment|
      g = Geocode.where(:address => establishment.address).first
      if g.present?
        establishment.update_attribute(:latlng, g.latlng)
      else
        # Create new geocode record so it will be caught in next geocoding run
        geocode = Geocode.create(:address => establishment.address)
        if geocode
          print "new Geocode created: #{geocode.id}\n"
        else
          print "tried to create new geocode but failed: #{geocode.id}\n"
        end
      end
    end
  end

  desc "Geocodes 1000 records at a time (but only if record is not geocoded already)"
  task :geocode => :environment do
    2500.times do 
      # Get new record to geocode
      g = Geocode.where("geocoding_results_json IS NULL").first
      puts g.id
      address = g.address.gsub " ", "+" #Replace spaces with '+' to make URL-safe
      map_url = "http://maps.googleapis.com/maps/api/geocode/json?address=#{address},+toronto,+on&sensor=false"
      puts "Map url is: #{map_url}"
      geo_json_raw = open(map_url).read
      geo_json_parsed = ActiveSupport::JSON.decode(geo_json_raw)
      if geo_json_parsed["status"] == "OK"
        g.geocoding_results_json = geo_json_raw
        lat = BigDecimal.new(geo_json_parsed["results"][0]["geometry"]["location"]["lat"], 10)
        lng = BigDecimal.new(geo_json_parsed["results"][0]["geometry"]["location"]["lng"], 10)
        g.latlng = "#{lat} ,#{lng}"
        geo_json_parsed["results"][0]["address_components"].each do |comp|
          comp["types"].each do |type|
            if type == "postal_code"
              g.postal_code = comp["long_name"]
            end
          end
        end
        g.save
      else
        puts geo_json_raw.inspect
        puts "RESULT STATUS IS **NOT OK** Status returned is: #{geo_json_parsed["status"]}"
        if geo_json_parsed["status"] == "ZERO_RESULTS"
          puts "ZERO_RESULTS found."
          g.geocoding_results_json = geo_json_raw
          g.save
        else
          sleep_time_pausing = 3600 # Wait an hour before trying another query
          puts "sleeping for #{sleep_time_pausing} seconds"
          sleep sleep_time_pausing
        end
      end
      sleep_how_long = [1].sample
      puts "sleeping #{sleep_how_long} sec..."
      sleep sleep_how_long
    end
  end

  desc "Fix establishment names and other information manually"
  task :fix_data_typos => :environment do
    # Need a task to help fix typos/invalid data from API. Can make this more
    #   extensible later if needed. For now, just fix the cases I've seen.
    # TODO: Move the rules into their own file so they're easier to define/modify.
    ESTABLISHMENT_NAME_FIXES = [
      { from: "KHAO SAN ROAP", to: "KHAO SAN ROAD" }
    ]
    ESTABLISHMENT_NAME_FIXES.each do |fix|
      establishments = Establishment.where(latest_name: fix[:from])
      establishments.each do |establishment|
        if establishment.update_attribute(:latest_name, fix[:to])
          puts "Establishment ID #{establishment.id} updated. Latest Name was: #{fix[:from]}, and is now: #{fix[:to]}"
        else
          puts "There was a problem updating establishment #{establishment.id}. Perhaps the name is invalid?"
        end
      end
    end
  end
end
