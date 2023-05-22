# encoding: UTF-8

require 'net/http'

# New data importer
namespace :dinesafe do
  # One-time task to convert xml files from jan 26, 2021 & feb 9, 2022 to JSON so they can be imported
  desc "Convert older file xml to json"
  task :convert_old_file_to_json => :environment do
    raise "!!! Already ran this, don't need to run again unless changes necessary!"

    dir = "doc/dinesafe_xml/"
    # filename = "ds - downloaded Jan 26, 2021.xml"
    filename = "ds - downloaded feb 9 2022.xml"
    xml_str = IO.read(Rails.root.join(dir, filename))

    hash = Hash.from_xml(xml_str.to_s)

    # Build up the records that we will output as json
    new_json = []

    # Track establishments that are missing inspections (for debugging)
    establishments_missing_inspections = []

    establishments = hash["DINESAFE_DATA"]["ESTABLISHMENT"]
    establishments.each do |establishment|
      establishments_missing_inspections << establishment unless establishment.key?("INSPECTION")

      establishment_fields = {
        "Establishment ID" => establishment["ID"].to_i,
        "Establishment Name" => establishment["NAME"],
        "Establishment Type" => establishment["TYPE"],
        "Establishment Address" => establishment["ADDRESS"],
        "Latitude" => establishment["LATITUDE"].to_f,
        "Longitude" => establishment["LONGITUDE"].to_f,
      }
      
      Array.wrap(establishment.fetch("INSPECTION", [])).each do |inspection|
        inspection_fields = {
          "Establishment Status" => inspection["STATUS"],
          "Inspection Date" => inspection["DATE"],
        }
        
        # Infractions are optional
        infractions = Array.wrap(inspection.fetch("INFRACTION", []))

        if infractions.present?
          infractions.each do |infraction|
            # Record for each infraction.
            new_json << establishment_fields.merge(inspection_fields).merge({
              # Infraction Fields
              "Severity" => infraction["SEVERITY"],
              # This is in one of the XML files but not the other (will be missing some infraction details):
              "Infraction Details" => infraction["DEFICIENCY"],
              "Action" => infraction["ACTION"],
              "Outcome" => infraction["COURT_OUTCOME"],
              "Amount Fined" => infraction["AMOUNT_FINED"].present? ? infraction["AMOUNT_FINED"].to_i : nil,
            })
          end
        else
          # Create record with blank infraction details (not always present, e.g. usually no infraction when inspection is a PASS)
          new_json << establishment_fields.merge(inspection_fields).merge({
            "Severity" => "",
            "Infraction Details" => "",
            "Action" => "",
            "Outcome" => "",
            "Amount Fined" => nil,
          })
        end
      end
    end

    puts "There were #{establishments_missing_inspections.size} establishment records with no inspections; these were skipped."
    puts "There are #{establishments.size} total establishments."
    puts "There are #{new_json.size} flattened records that will be output to the json file."

    # Output hash to JSON file
    json_filename = "#{File.basename(filename, File.extname(filename))}.json"
    json_path = Rails.root.join(dir, json_filename)
    IO.write(json_path, JSON.generate(new_json))
  end

  desc "Download and import latest dinesafe xml file"
  task :update_data_new => :environment do
    Rails.logger.info("Starting dinesafe:update_data_new data import")

    uri = URI('https://ckan0.cf.opendata.inter.prod-toronto.ca/dataset/ea1d6e57-87af-4e23-b722-6c1f5aa18a8d/resource/c573c64d-69b6-4d5b-988a-f3c6aa73f0b0/download/Dinesafe.json')
    result = Net::HTTP.get(uri)

    # TODO: Manually run imports for these 2 files (maybe locally), to backfill data.
    # result = IO.read(Rails.root.join("doc/dinesafe_xml/ds - downloaded Jan 26, 2021.json"))
    # result = IO.read(Rails.root.join("doc/dinesafe_xml/ds - downloaded feb 9 2022.json"))
    # result = IO.read(Rails.root.join("doc/dinesafe_xml/Dinesafe (1) - downloaded May 13, 2023.json"))

    json = JSON.parse(result)

    # Group by Establishment (by ID), then Inspection (by Date)
    # Will have one record for each infraction (if applicable)
    grouped = json
      .reject { |j| j["Inspection Date"].nil? } # If inspection date is nil, we want to ignore those records
      .group_by { |j| j["Establishment ID"] }
      .transform_values { |est_json| est_json.group_by { |j| j["Inspection Date"] } }

    progress_bar = ProgressBar.create(
      throttle_rate: 1,
      format: "%a |%b>%i| %p%% %e Establishments: %c/%C",
      total: grouped.size,
    )

    # Log last updated dates so we can calculate how many records created/updated
    last_updated = {
      establishment: Establishment.maximum(:updated_at),
      inspection: Inspection.maximum(:updated_at),
      infraction: Infraction.maximum(:updated_at),
    }

    grouped.each do |est_id, est_data|
      Rails.logger.info "Establishment: #{est_id}"

      establishment = Establishment.with_deleted.find_or_create_by(id: est_id.to_i)
      current_address = establishment.address

      # All records have establishment data, so just grab from the first one
      est_record = est_data.values.flatten.first

      # The data feed now has latlng, so no need to geocode
      latlng = [est_record.fetch("Latitude"), est_record.fetch("Longitude")].join(",")

      establishment.update!(
        latest_name: est_record.fetch("Establishment Name").strip,
        latest_type: est_record.fetch("Establishment Type").strip,
        address: est_record.fetch("Establishment Address"),
        latlng: latlng,
        # Undelete in case establishment was previously deleted, then added again.
        deleted_at:   nil,
      )

      if current_address != establishment.address
        Rails.logger.info "Change detected! Old: #{current_address} New: #{establishment.address} (Establishment ID: #{est_id})"
      end

      est_data.each do |inspection_date, inspection_data|
        # We no longer have Inspection IDs, so lookup inspections by date
        inspection = establishment.inspections.find_or_create_by(date: inspection_date.strip)
        
        # We'll have multiple records if there are multiple infractions, but inspection data is same in all
        inspection_record = inspection_data.first

        inspection.update!(
          establishment_name: est_record.fetch("Establishment Name").strip,
          establishment_type: est_record.fetch("Establishment Type").strip,
          status: inspection_record.fetch("Establishment Status").strip,
          # This is not present in Jan 26, 2021 file. Hopefully will not end up with any actual 0 values after all imports
          minimum_inspections_per_year: inspection_record.fetch("Min. Inspections Per Year", nil)&.to_i,
        )

        # for each infraction (i.e. each record in inspection_data)
        inspection_data.each do |infraction_record|
          # One of the older files had no infraction details, so don't create a record in that case
          next if infraction_record["Infraction Details"].to_s.strip.blank?

          infraction_attributes = {
            details: infraction_record.fetch("Infraction Details").to_s.strip,
            severity: infraction_record.fetch("Severity").to_s.strip,
            action: infraction_record.fetch("Action").to_s.strip,
            court_outcome: infraction_record.fetch("Outcome").to_s.strip,
            amount_fined: infraction_record.fetch("Amount Fined").to_f,
          }

          if (infraction_attributes[:details].present? or
            infraction_attributes[:severity].present? or
            infraction_attributes[:action].present? or
            infraction_attributes[:court_outcome].present? or
            infraction_attributes[:amount_fined] > 0)
              # This combination of attributes should always be unique
              infraction = inspection.infractions.where(
                severity: infraction_attributes[:severity],
                details: infraction_attributes[:details],
                amount_fined: infraction_attributes[:amount_fined]
              ).first_or_create
              infraction.update!(infraction_attributes)
          end
        end
      end

      progress_bar.increment
    end

    # Report on changed 
    updated_counts = {
      establishment: Establishment.where("updated_at > ?", last_updated[:establishment]).count,
      inspection: Inspection.where("updated_at > ?", last_updated[:inspection]).count,
      infraction: Infraction.where("updated_at > ?", last_updated[:infraction]).count,
    }
    puts "Number of records updated/created:"
    puts updated_counts

    # Delete all establishments that are no longer in the file (assume they are now closed)
    # Note that we use the initial list, as if an establishment is in the file, we'll assume
    # it's still active (even if it doesn't have any inspection data)
    all_establishment_ids = json.map { |j| j["Establishment ID"] }.uniq
    Establishment.where.not(id: all_establishment_ids).update_all(deleted_at: Time.zone.now)
  end
end

