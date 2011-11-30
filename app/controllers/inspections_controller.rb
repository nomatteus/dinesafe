class InspectionsController < ApplicationController
  def index
    @establishments = []
    Inspection.establishments.order(:establishment_name).first(500).each do |est|
      

      @establishments << {
        :id => est.establishment_id,
        :name => est.establishment_name,
        :type => est.establishment_type,
        :address => est.establishment_address,
        :inspections => Inspection.where(:establishment_id => est.establishment_id).order(:inspection_date)
      }
    end
  end

end
