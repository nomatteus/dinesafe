class EstablishmentsController < ApplicationController

  # TODO: DRY up this code! And move a bunch of it to the models, perhaps?
  #       There is a lot of repetition between index and show methods....
  #       But I want to focus on the iOS dev stuff for now...

  def index
    current_page = params[:page].to_i > 0 ? params[:page].to_i : 1
    per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 30
    if params[:near].present? # TODO? Add regex to check format? or just check for comma?
      lat, lng = params[:near].split(",")
      establishments = Establishment.near(lat, lng)
    else
      establishments = Establishment
    end
    if params[:search].present?
      establishments = establishments.where("latest_name ILIKE ?", "%#{params[:search]}%")
    end
    total_pages = (establishments.count.to_f / per_page.to_f).ceil
    establishments = establishments.paginate(:page => current_page, :per_page => per_page).order(:latest_name)
    @establishment_list = []
    establishments.each do |establishment|

      inspections_list = []
      # TODO: use .includes(:inspections) on establishments query, then order
      #       inspections by date using Ruby instead of DB query.
      establishment.inspections.order(:date).each do |inspection|
        # Add all inspection info, except for infractions!
        inspections_content = {
          :id => inspection.id,
          :status => inspection.status,
          :date => inspection.date,
          :minimum_inspections_per_year => inspection.minimum_inspections_per_year,
          :establishment_name => inspection.establishment_name.titleize,
          :establishment_type => inspection.establishment_type,
        }
        inspections_list << inspections_content
      end

      establishment_content = {
        :id => establishment.id,
        :latest_name => establishment.latest_name.titleize,
        :latest_type => establishment.latest_type,
        :address => establishment.address.titleize,
        :latlng => establishment.latlng_dict,
        :inspections => inspections_list
      }
      if establishment[:distance].present?
        establishment_content[:distance] = establishment.distance.to_f
      end
      @establishment_list << establishment_content
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { 
        render :json => {
          :data => @establishment_list,
          :paging => {
            :current_page => current_page,
            :total_pages => total_pages,
          }
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
    establishment.inspections.order(:date).includes(:infractions).each do |inspection|
      infractions_list = []
      inspection.infractions_by_severity.each do |infraction|
        infraction_content = {
          :id            => infraction.id,
          :inspection_id => inspection.id,
          :details       => infraction.details,
          :severity      => infraction.severity_for_api,
          :action        => infraction.action,
          :court_outcome => infraction.court_outcome,
          :amount_fined  => infraction.amount_fined,
        }
        infractions_list << infraction_content
      end
      inspections_content = {
        :id => inspection.id,
        :status => inspection.status,
        :date => inspection.date,
        :infractions => infractions_list,
        :minimum_inspections_per_year => inspection.minimum_inspections_per_year,
        :establishment_name => inspection.establishment_name.titleize,
        :establishment_type => inspection.establishment_type,
      }
      inspections_list << inspections_content
    end
    establishment_content = {
      :id => establishment.id,
      :latest_name => establishment.latest_name.titleize,
      :latest_type => establishment.latest_type,
      :address => establishment.address.titleize,
      :latlng => establishment.latlng_dict,
      :inspections => inspections_list
    }
    if establishment[:distance].present?
      establishment_content[:distance] = establishment.distance.to_f
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { 
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
