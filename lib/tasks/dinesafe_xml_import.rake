# encoding: UTF-8
require 'open-uri'

namespace :dinesafe do
  desc "Update task"
  task update_data: :environment do
    Rake::Task["dinesafe:update_xml"].execute
    Rake::Task["dinesafe:xml_import"].execute
    Rake::Task["dinesafe:fix_data_typos"].execute
    Rake::Task["dinesafe:geocode"].execute
    Rake::Task["dinesafe:update_latlngs"].execute
    # Run again to catch any geocodes created
    Rake::Task["dinesafe:geocode"].execute
    Rake::Task["dinesafe:update_latlngs"].execute
  end


  desc "Download and extract latest dinesafe.xml file"
  task :update_xml => :environment do
    file_url = "http://opendata.toronto.ca/public.health/dinesafe/dinesafe.zip"
    # TODO: Sometimes the xml filename isn't "dinesafe.xml" (was "dinesafe2011.xml" once),
    #       so should adapt script to work with any .xml filename within the zip.
    dinesafe_xml_file       = Rails.root.to_s + "/doc/dinesafe.xml"
    dinesafe_xml_temp_file  = Rails.root.to_s + "/doc/DELETE_OLD_dinesafe.xml"
    dinesafe_zip_temp_path  = Rails.root.to_s + "/doc/tmp_dinesafe.zip"
    dinesafe_zip_folder     = Rails.root.to_s + "/doc"

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
    doc = Nokogiri::XML(open(Rails.root.to_s + "/doc/dinesafe.xml"))
    rows = doc.xpath("//ROW")
    total_rows = rows.length

    progress_bar = ProgressBar.create(
      throttle_rate: 1,
      format: "%a |%b>%i| %p%% %e Rows: %c/%C",
      total: total_rows,
    )

    rows.each do |row|
      # Note: It appears ROW_ID will not always refer to the same establishment/restaurant
      #       Instead, we might have to use the Inspection ID as unique key
      #       So, don't rely on/use ROW_ID at all!

      # Create or Update Establishment
      establishment = Establishment.find_or_create_by(id: row.xpath("ESTABLISHMENT_ID").text.to_i)
      current_address = establishment.address
      establishment.update_attributes({
        latest_name:  row.xpath("ESTABLISHMENT_NAME").text,
        latest_type:  row.xpath("ESTABLISHMENTTYPE").text,
        address:      row.xpath("ESTABLISHMENT_ADDRESS").text,
      })

      if current_address != establishment.address
        Rails.logger.info "Change detected! Old: #{current_address} New: #{establishment.address}"
      end
      #puts "Updated establishment ID: #{establishment.id}"

      # Log inspection for Establishment
      Rails.logger.info establishment.id.to_s
      Rails.logger.info row.xpath("INSPECTION_DATE").text
      Rails.logger.info row.xpath("INFRACTION_DETAILS").text
      # The assumption here is that all inspections on the same date
      #  will have the same establishment status and min inspections.
      #  From what I've seen in the data, this is the case, and it makes sense.
      inspection = Inspection.find_or_create_by(id: row.xpath("INSPECTION_ID").text.to_i)
      inspection.update_attributes({
        establishment_id:              establishment.id,
        establishment_name:            row.xpath("ESTABLISHMENT_NAME").text.strip,
        establishment_type:            row.xpath("ESTABLISHMENTTYPE").text.strip,
        status:                        row.xpath("ESTABLISHMENT_STATUS").text.strip,
        minimum_inspections_per_year:  row.xpath("MINIMUM_INSPECTIONS_PERYEAR").text.to_i,
        date:                          row.xpath("INSPECTION_DATE").text.strip,
      })
      # Create each infraction if there is one.
      infraction_attributes = {
        inspection_id:      inspection.id,
        details:            row.xpath("INFRACTION_DETAILS").text.strip, # ** infraction
        severity:           row.xpath("SEVERITY").text.strip, # ** infraction
        action:             row.xpath("ACTION").text.strip, # ** infraction
        court_outcome:      row.xpath("COURT_OUTCOME").text.strip, # ** infraction
        amount_fined:       row.xpath("AMOUNT_FINED").text.to_f # ** infraction
      }
      if (infraction_attributes[:details].present? or
        infraction_attributes[:severity].present? or
        infraction_attributes[:action].present? or
        infraction_attributes[:court_outcome].present? or
        infraction_attributes[:amount_fined] > 0)
          # This combination of attributes should always be unique
          infraction = Infraction.where(
            inspection_id: infraction_attributes[:inspection_id],
            severity: infraction_attributes[:severity],
            details: infraction_attributes[:details],
            amount_fined: infraction_attributes[:amount_fined]
          ).first_or_create
          infraction.update_attributes(infraction_attributes)
      end

      progress_bar.increment
    end
  end

  desc "Update latlng establishments (uses geocode table, so update geocode info first)"
  task :update_latlngs => :environment do
    Establishment.where("latlng IS NULL").each do |establishment|
      g = Geocode.where(address: establishment.address).first
      if g.present?
        establishment.update_attribute(:latlng, g.latlng)
      else
        # Create new geocode record so it will be caught in next geocoding run
        geocode = Geocode.create(address: establishment.address)
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
    Geocode.where("geocoding_results_json IS NULL").first(2500).each do |g|
      # Get new record to geocode
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
    # Do not include this establishment, as it is a sensitive address (Red Door Family Shelter)
    Establishment.where(id: 10507645).destroy_all
  end
end
