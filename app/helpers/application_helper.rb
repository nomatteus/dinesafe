module ApplicationHelper

  def to_class_name(text)
    return text.downcase.gsub(%r{\s+}, '-')
  end

  def google_static_map_link(latlng, size)
    "http://maps.googleapis.com/maps/api/staticmap?center=#{latlng[:lat]},#{latlng[:lng]}&markers=color:red%7C#{latlng[:lat]},#{latlng[:lng]}&scale=2&zoom=15&size=#{size}&key=#{Dinesafe.conf.google_maps_browser_api_key}&sensor=true"
  end

  def facebook_og_tags
    if @establishment.present?
      title = "Dinesafe results for #{@establishment.name}"
      desc = "This establishment has #{@establishment.inspections.count} total inspections. Visit link to view full history, and see if this place has passed all inspections."
    else
      title = "Dinesafe Toronto iOS App - Restaurant Health Inspections"
      desc = "View restaurant health inspections on the go. Browse nearby establishments, or search for your faves. View inspection history up to 3 years."
    end
    %Q{
      <meta property="og:title" content="#{title}"/>
      <meta property="og:description" content="#{desc}"/>
      <meta property="og:image" content="http://dinesafe.to/assets/logos/dinesafe-128-square.png"/>
      <meta property="og:type" content="website"/>
      <meta property="fb:admins" content="122611956"/>
    }.html_safe
  end

end
