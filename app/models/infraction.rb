class Infraction < ApplicationRecord
  belongs_to :inspection

  def severity_for_api
    case severity
    when "S - Significant"
      "Significant"
    when "M - Minor"
      "Minor"
    when "C - Crucial"
      "Crucial"
    else
      self.severity
    end
  end
end
