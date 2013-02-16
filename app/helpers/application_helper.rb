module ApplicationHelper

  def to_class_name(text)
    return text.downcase.gsub(%r{\s+}, '-')
  end

  def google_static_map_link(latlng, size)
    "http://maps.googleapis.com/maps/api/staticmap?center=#{latlng[:lat]},#{latlng[:lng]}&markers=color:red%7C#{latlng[:lat]},#{latlng[:lng]}&scale=2&zoom=15&size=#{size}&key=#{Dinesafe.conf.google_maps_browser_api_key}&sensor=true"
  end

end
