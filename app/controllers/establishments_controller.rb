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

    # Track Fathom event only if page param is explicitly set and current_page == 1
    if params[:page].present? && @current_page == 1
      goal_code = params[:search]&.strip.present? ? ENV['FATHOM_ESTABLISHMENT_SEARCH_EVENT_ID'] : ENV['FATHOM_ESTABLISHMENT_LIST_EVENT_ID']
      track_fathom_event(goal_code)
    end

    respond_to do |format|
      format.json
    end
  end

  def show
    # Track Fathom event for establishment detail views
    track_fathom_event(ENV['FATHOM_ESTABLISHMENT_DETAILS_EVENT_ID'])

    respond_to do |format|
      format.json
    end
  end

  # Establishment view with app promo (landing page style)
  def show_app
    @inspections = @establishment.inspections

    render :layout => "application_responsive"
  end

protected

  # Temp: Track Fathom events manually
  def track_fathom_event(goal_code)
    return unless Rails.env.production?
    return unless goal_code
    
    uri = URI("https://cdn.usefathom.com/")
    params = {
      gcode: goal_code,
      gval: 0,
      qs: '{}',
      p: '/ios-app',
      h: 'https://dinesafe.to',
      r: '',
      sid: 8.times.map { ('A'..'Z').to_a.sample }.join,
      cid: rand(10_000_000..99_999_999)
    }
    uri.query = URI.encode_www_form(params)
    
    req = Net::HTTP::Post.new(uri)
    req['User-Agent'] = "DineSafe-API/1.0"
    req['Accept'] = "*/*"
    req['Origin'] = "https://dinesafe.to"
    req['Content-Length'] = "0"
    
    Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(req)
    end
    
    Rails.logger.info "Successfully tracked Fathom event: #{goal_code}"
  rescue => e
    Rails.logger.error "Failed to track Fathom event '#{goal_code}': #{e.message}"
  end

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
