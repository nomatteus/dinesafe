class AddDistanceStoredProcedure < ActiveRecord::Migration
  def up
    # From here: http://yaboolog.blogspot.ca/2011/08/postgres-tips-stored-procedure-for.html
    # (Modified to return KM instead of meters)
    # TO DO: Verify this is a good method
    execute "
      CREATE FUNCTION GET_DISTANCE_KM
          (alat FLOAT, alon FLOAT, lat FLOAT, lon FLOAT)
      RETURNS FLOAT AS
      $$
      DECLARE
          radius_earth FLOAT;
          radian_lat FLOAT;
          radian_lon FLOAT;
          distance_v FLOAT;
          distance_h FLOAT;
          distance FLOAT;
      BEGIN
          -- Insert earth radius
          SELECT INTO radius_earth 6378.137;
       
          -- Calculate difference between lat and alat
          SELECT INTO radian_lat radians(lat - alat);
       
          -- Calculate difference between lon and alon
          SELECT INTO radian_lon radians(lon - alon);
       
          -- Calculate vertical distance
          SELECT INTO distance_v (radius_earth * radian_lat);
       
          -- Calculate horizontal distance
          SELECT INTO distance_h (cos(radians(alat)) * radius_earth * radian_lon);
       
          -- Calculate distance(km)
          SELECT INTO distance sqrt(pow(distance_h,2) + pow(distance_v,2));
       
          -- Returns distance
          RETURN DISTANCE;
      END;
      $$ language plpgsql;
    "
  end

  def down
    execute "DROP FUNCTION GET_DISTANCE_KM(alat FLOAT, alon FLOAT, lat FLOAT, lon FLOAT)"
  end
end
