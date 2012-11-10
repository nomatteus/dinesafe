class EstablishmentController < ApplicationController

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
