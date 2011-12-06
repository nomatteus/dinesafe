class Inspection < ActiveRecord::Base
  belongs_to :establishment

  #def self.establishments
  #  self.group(:establishment_id)
  #end

end
