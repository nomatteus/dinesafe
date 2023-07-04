class EstablishmentsController < ApplicationController
  before_action :load_establishment, :only => [ :show, :show_app ]

  def index
    @current_page = params[:page].to_i > 0 ? params[:page].to_i : 1
    @per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 30

    establishments_scope = establishment_proximity_scope
    establishments_scope = establishment_search_scope(establishments_scope)

    @total_pages = (establishments_scope.count(:all).to_f / @per_page.to_f).ceil
    if establishments_scope.count(:all) > 0
      @establishments = establishments_scope
                          .includes(:inspections)
                          .limit(@per_page)
                          .offset((@current_page - 1) * @per_page)
                          .order(:latest_name)
    end

    respond_to do |format|
      format.json
    end
  end

  def show
    respond_to do |format|
      format.json
    end
  end

  # Establishment view with app promo (landing page style)
  def show_app
    render :layout => "application_responsive"
  end

protected

  def load_establishment
    @establishment = establishment_proximity_scope
                        .includes(:inspections => :infractions)
                        .find(params[:id])
  end

  # Return Establishment proximity scope if "near" parameter set and valid
  def establishment_proximity_scope
    lat, lng = params[:near].split(",") if params[:near].present?
    if lat.present? && lng.present?
      Establishment.near(lat.to_f, lng.to_f)
    else
      Establishment
    end
  end

  def establishment_search_scope(establishments_scope)
    return establishments_scope unless params[:search].present?

    params[:search].strip!

    # Find the first number to use as number of days for some searches (may be nil)
    num_days = params[:search].scan(/\d+/).first&.to_i

    case params[:search]
    when /new:/i
      # Search for new establishments, i.e. first ever inspection in the last X days
      # TODO
    when /recent:/i
      # Search for establishments with inspections, i.e. last inspection was in the last X days (default 7)
      establishments_scope.joins(:inspections).where("inspections.date >= now() - interval '? days'", num_days || 7)
    when /closed:/i
      # Search for establishments with a closed inspection. Optionally in the last X days. 
      # TODO
    when /conditional:/i
      # Search for establishments with a conditional inspection. Optionally in the last X days. 
      # TODO
    else
      establishments_scope.where("latest_name ILIKE ?", "%#{params[:search]}%")
    end
  end

end
