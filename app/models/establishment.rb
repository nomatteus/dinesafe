class Establishment < ActiveRecord::Base
  has_many :inspections

  acts_as_mappable  :default_units => :kilometers,
                    :default_formula => :sphere


  def inspections_json_parsed
    JSON.parse(inspections_json)
  end
end
