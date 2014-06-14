class Establishment < ActiveRecord::Base
  include Rails.application.routes.url_helpers

  has_many :inspections, -> { order("date ASC") }

  scope :near, ->(lat, lng) { 
    select("get_distance_km(#{lat}, #{lng}, latlng[0], latlng[1]) as distance, *")
    .order("distance ASC")
  }

  def latlng_dict
    return if self.latlng.nil?
    return {
      :lat => latlng[0].to_f,
      :lng => latlng[1].to_f
    }
  end

  def name
    self.latest_name.present? ? self.latest_name.titleize : ""
  end

  # Full address. All Toronto for now!
  def address_full
    "#{self.address.titleize}, Toronto, ON"
  end

  def slug
    self.name.parameterize
  end

  # Short version of share text. TWEET Length or less.
  def share_text_short
    # TODO: Update this. Make configurable in settings.yml?
    "I'm looking at #{self.latest_name.titleize} on Dinesafe."
  end

  # Longer version of share text
  def share_text_long
    # For now, just make it the same as short version
    "" + self.share_text_short
  end

  # HTML Version of long share text, for Email
  def share_text_long_html
    # For now, just make it the same as short version
    "<b>#{self.share_text_long}</b>"
  end

  def share_url
    Dinesafe::SITE_URL + establishment_landing_path(self.id, self.slug)
  end

end
