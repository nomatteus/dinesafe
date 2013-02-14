class EstablishmentsController < ApplicationController
  before_filter :load_establishment, :only => [ :show, :show_app ]

  def index
    @current_page = params[:page].to_i > 0 ? params[:page].to_i : 1
    @per_page = params[:per_page].to_i > 0 ? params[:per_page].to_i : 30

    establishments_scope = establishment_proximity_scope
    if params[:search].present?
      params[:search].strip!
      establishments_scope = establishments_scope.where("latest_name ILIKE ?", "%#{params[:search]}%")
    end

    @total_pages = (establishments_scope.count.to_f / @per_page.to_f).ceil
    @establishments = establishments_scope
                        .includes(:inspections)
                        .paginate(:page => @current_page, :per_page => @per_page)
                        .order(:latest_name)

    respond_to do |format|
      # format.html # index.html.erb
      format.json # index.json.jbuilder
    end
  end

  def show
    respond_to do |format|
      format.json # show.json.jbuilder 
    end
  end

  # Establishment view with app promo (landing page style)
  def show_app
    # raise params[:id].to_yaml
    render :layout => "landing"
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

end
