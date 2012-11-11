class InspectionsController < ApplicationController
  def index
    @establishments = Establishment.last(100) #where("address ILIKE '%king%'")
  end

  def map
    
  end

  # A method to be called via javascript, will return a JSON list of inspections 
  def search
  end

end
