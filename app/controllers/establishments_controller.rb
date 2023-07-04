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

    # Allow searching by restaurant type (to exclude the various other establishment types)
    establishments_scope = establishments_scope.restaurants if params[:search].match?("type:restaurant")

    # Find the first number to use as number of days for some searches (may be nil)
    num_days = params[:search].scan(/\d+/).first&.to_i

    # Support different types of searches to allow searching for different types of 
    # establishments/inspections. Note that this is a bit hacky for now, but allows
    # testing out different search views without making iOS app updates.
    # TODO: Move these scopes to the model to clean this up a bit
    case params[:search]
    when /new:/i
      # Search for new establishments, i.e. first ever inspection in the last X days
      establishments_scope.where("min_inspection_date >= now() - interval '? days'", num_days || 7)
    when /recent:/i
      # Search for establishments with recent inspection, i.e. last inspection was in the last X days (default 7)
      establishments_scope.where("max_inspection_date >= now() - interval '? days'", num_days || 7)
    when /closed:/i
      # Search for establishments with a closed inspection. Optionally in the last X days. 
      establishments_scope.where("last_closed_inspection_date >= now() - interval '? days'", num_days || 365*20)
    when /conditional:/i
      # Search for establishments with a conditional inspection. Optionally in the last X days. 
      establishments_scope.where("last_conditional_inspection_date >= now() - interval '? days'", num_days || 365*20)
    else
      establishments_scope.where("latest_name ILIKE ?", "%#{params[:search]}%")
    end
  end

end
