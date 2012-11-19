class Inspection < ActiveRecord::Base
  # Default sort for inspections: "Crucial", "Significant", "Minor"
  SORT_ORDER = "CSM"

  belongs_to :establishment
  has_many :infractions

  # Returns list of infractions, sorted by severity (as defined in SORT_ORDER)
  def infractions_by_severity
    # Use SORT_ORDER to map the severity to an array index, then sort on that
    self.infractions.sort_by { |infraction| SORT_ORDER.index(infraction.severity[0]) }
  end
end
