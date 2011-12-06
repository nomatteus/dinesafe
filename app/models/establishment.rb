class Establishment < ActiveRecord::Base
  has_many :inspections

  def inspections_json_parsed
    JSON.parse(inspections_json)
  end
end
