class Inspection < ApplicationRecord
  # Default sort for inspections: "Crucial", "Significant", "Minor"
  SORT_ORDER = "CSM"

  belongs_to :establishment
  has_many :infractions

  scope :pass, -> { where(status: "Pass") }
  scope :conditional, -> { where(status: "Conditional Pass") }
  scope :closed, -> { where(status: "Closed") }

  # Returns list of infractions, sorted by severity (as defined in SORT_ORDER)
  def infractions_by_severity
    # Use SORT_ORDER to map the severity to an array index, then sort on that
    # If not found in SORT_ORDER, then sort by the ascii code of character
    #   "A".ord is 65, so these will all appear in alphabetical order after 
    #    anything in SORT_ORDER
    self.infractions
      .reject{ |infraction| infraction.severity.empty? }
      .sort_by { |infraction| 
        SORT_ORDER.index(infraction.severity[0].upcase) || infraction.severity[0].upcase.ord
      }
  end
end
