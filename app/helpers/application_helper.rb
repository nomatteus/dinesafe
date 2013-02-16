module ApplicationHelper

  def to_class_name(text)
    return text.downcase.gsub(%r{\s+}, '-')
  end

  def google_static_map_link(address, size)
    "http://maps.googleapis.com/maps/api/staticmap?center=#{URI.escape(address)}&zoom=13&size=#{size}&key=#{Dinesafe.conf.google_maps_browser_api_key}&sensor=false"
  end

end
