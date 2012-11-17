class EstablishmentsController < ApplicationController

  def index
    if params[:near].present? # TODO? Add regex to check format? or just check for comma?
      lat, lng = params[:near].split(",")
      establishments = Establishment.near(lat, lng)
    else
      establishments = Establishment
    end
    if params[:search].present?
      establishments = establishments.where("name ILIKE ?", "%#{params[:search]}%")
    end
    establishments = establishments.paginate(:page => params[:page], :per_page => 30).order(:name)
    @establishment_list = []
    establishments.each do |establishment|
      establishment_content = {
        :id => establishment.id,
        :name => establishment.name,
        :type => establishment.est_type,
        :address => establishment.address,
        :postal_code => establishment.postal_code,
        :latlng => establishment.latlng,
      }
      if establishment[:distance].present?
        establishment_content[:distance] = establishment.distance
      end
      @establishment_list << establishment_content
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        # Select specific fields for API
        render :json => {
          :data => @establishment_list
          }.to_json
      }
    end
  end

  def show
    if params[:near].present? # TODO? Add regex to check format? or just check for comma?
      lat, lng = params[:near].split(",")
      # establishments = Establishment.near(lat, lng)
      establishment = Establishment.near(lat, lng).find(params[:id])
    else
      establishment = Establishment.find(params[:id])
    end
    inspections_list = []
    establishment.inspections.each do |inspection|
      inspections_content = {
        :id => inspection.id,
        :infractions => inspection.infractions
      }
      # inspections.each do |inspection|
      #   inspections_content[:details] << {
      #   :status => inspection.status,
      #   :minimum_inspections_per_year => inspection.minimum_inspections_per_year,
      #   :infraction_details => inspection.infraction_details,
      #   :date => inspection.date,
      #   :severity => inspection.severity,
      #   :action => inspection.action,
      #   :court_outcome => inspection.court_outcome,
      #   :amount_fined => inspection.amount_fined,
      #   :inspection_id => inspection.inspection_id,
      #   }
      # end
      inspections_list << inspections_content
    end
    establishment_content = {
      :id => establishment.id,
      :name => establishment.name,
      :type => establishment.est_type,
      :address => establishment.address,
      :postal_code => establishment.postal_code,
      :latlng => establishment.latlng,
      :inspections => inspections_list
    }
    if establishment[:distance].present?
      establishment_content[:distance] = establishment.distance
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        # Select specific fields for API
        render :json => {
          :data => establishment_content
          }.to_json
      }
    end
  end

  # A method to be called via javascript, will return a JSON list of establishments,
  #   with the search parameters specified.
  def search
    # Main thing should be a "bounds", which will let users search within
    # a specific bounds.
    # Establishments should be grouped if there are many in one area (or zoomed out like crazy)
    #   figure out whether to do this with JS or ruby. 
    #   could have 2 different marker types.

    # Use geokit to do bounds search https://github.com/jlecour/geokit-rails3]
    render :json => {:something => params[:blah]}
  end

end
