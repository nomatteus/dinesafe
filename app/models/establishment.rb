class Establishment < ActiveRecord::Base
  has_many :inspections

  scope :near, lambda { |lat, lng|
    select("get_distance_km(#{lat}, #{lng}, latlng[0], latlng[1]) as distance, *")
    .order("point(#{lat}, #{lng}) <-> latlng ASC")
  }

end
