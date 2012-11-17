class Inspection < ActiveRecord::Base
  belongs_to :establishment
  has_many :infractions
end
