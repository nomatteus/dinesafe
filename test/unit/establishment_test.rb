require 'test_helper'

class EstablishmentTest < ActiveSupport::TestCase

  def setup
    @est1 = establishments(:one)
    @est2 = establishments(:two)
  end

  test "latlng_dict" do
    assert_equal({:lat => 43.6982039, :lng => -79.5027124}, @est1.latlng_dict)
    assert_equal({:lat => 43.688205, :lng => -79.5027122}, @est2.latlng_dict)
  end

  test "latlng_dict with nil latlng returns nil" do
    @est1.update_attribute(:latlng, nil)
    assert_nil @est1.latlng
    assert_nil @est1.latlng_dict
  end

  test "name" do
    @est1.update_attribute(:latest_name, "AN UPPERCASE NAME")
    assert_equal "An Uppercase Name", @est1.name
  end

  test "address full" do
    assert_equal "1550 Jane St, Toronto, ON", @est1.address_full
  end

  test "slug" do
    assert_equal "an-establishment", @est1.slug
    assert_equal "another-establishment", @est2.slug
  end

  test "share text short" do
    assert_equal "I'm looking at #{@est1.latest_name.titleize} on Dinesafe.", @est1.share_text_short
  end

  test "share text long" do
    assert_equal "I'm looking at #{@est1.latest_name.titleize} on Dinesafe.", @est1.share_text_long
  end

  test "share text long HTML" do
    expected_share_text =  %Q{<b>I'm looking at #{@est1.latest_name.titleize} on Dinesafe.</b>}
    assert_equal expected_share_text, @est1.share_text_long_html
  end

  test "share url" do
    assert_equal "#{Dinesafe::SITE_URL}/app/place/#{@est1.id}/#{@est1.slug}", @est1.share_url
  end

  test "soft delete" do
    assert_difference "Establishment.count", -1 do
      assert_no_difference "Establishment.with_deleted.count" do
        @est1.destroy
      end
    end
  end

  test "soft delete deleted at" do
    assert_difference "Establishment.count", -1 do
      @est1.update_column(:deleted_at, Time.zone.now)
    end
  end

  test "near scope" do
    assert_not_nil @est1.earth_coord
    assert_not_nil @est2.earth_coord
    # Note that establishment 1 is a bit above establishment 2
    # First, use a point south of both points.
    establishments = Establishment.near(43.6411026,-79.4677921).to_a
    assert_equal [@est2, @est1], establishments
    assert_in_delta 5.95, establishments[0][:distance], 0.01
    assert_in_delta 6.95, establishments[1][:distance], 0.01

    # Then use a point north of both points
    establishments = Establishment.near(43.7720739,-79.5962059).to_a
    assert_equal [@est1, @est2], establishments
    assert_in_delta 11.14, establishments[0][:distance], 0.01
    assert_in_delta 11.98, establishments[1][:distance], 0.01
  end

  test "earth_coord field updated on create/save" do
    establishment = Establishment.create!(
      latest_name: "An establishment",
      latest_type: "Restaurant",
      address: "1550 Jane St",
      latlng: "43.6982039,-79.5027124"
    )
    establishment.reload
    assert_equal "(840136.058119947, -4534166.44419922, 4406419.53249671)", establishment.earth_coord

    # Test that it's updated when latlng updates
    establishment.update_attribute(:latlng, "43.682324,-79.5134422")
    establishment.reload
    assert_equal "(839509.172955397, -4535524.39301286, 4405141.29911097)", establishment.earth_coord
  end

end
