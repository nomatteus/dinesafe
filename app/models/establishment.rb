class Establishment < ApplicationRecord
  include Rails.application.routes.url_helpers
  acts_as_paranoid

  has_many :inspections, -> { order("date ASC") }

  after_save :update_earth_coord

  scope :near, ->(lat, lng) {
    select("earth_distance(ll_to_earth(#{lat}, #{lng}), earth_coord)/1000 as distance, *")
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

private

  def update_earth_coord
    Establishment.where(id: self.id).update_all("earth_coord = ll_to_earth(latlng[0], latlng[1])")
  end

end
