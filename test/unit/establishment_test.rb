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

  test "share text" do
    assert_equal "My share text... for #{@est1.latest_name.titleize}", @est1.share_text
  end

  test "share url" do
    assert_equal "#{Dinesafe::SITE_URL}/app/establishment/#{@est1.id}", @est1.share_url
  end

end
