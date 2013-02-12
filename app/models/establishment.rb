class Establishment < ActiveRecord::Base
  has_many :inspections, :order => "date ASC"

  scope :near, lambda { |lat, lng|
    select("get_distance_km(#{lat}, #{lng}, latlng[0], latlng[1]) as distance, *")
    .order("distance ASC")
  }

  def latlng_dict
    # Remove brackets and split on comma
    parts = self.latlng[1..-2].split(",")
    return {
      :lat => parts[0].to_f,
      :lng => parts[1].to_f
    }
  end

  def share_text
    # TODO: Update this. Make configurable in settings.yml?
    "My share text... for #{self.latest_name.titleize}"
  end

  def share_url
    # TODO: Use _path helper for url gen instead of hardcoding
    "#{Dinesafe::SITE_URL}/app/establishment/#{self.id}"
  end

end
