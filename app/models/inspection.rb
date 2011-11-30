class Inspection < ActiveRecord::Base

  def self.establishments
    self.group(:establishment_id)
  end

end
