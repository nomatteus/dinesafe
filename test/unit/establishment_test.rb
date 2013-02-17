require 'test_helper'

class EstablishmentTest < ActiveSupport::TestCase

  # test "establishment proximity search" do
    # flunk
    # how to test :near scope?
    # create array of ~3 places (or add them to yaml)
    # then run scope with limit of 1 and make sure it's
    #  the closest one.
    # Or run with limit of 3 and check that they're all in
    # the correct order
  # end
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

end
