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

  test "latlng_dict" do
    est1 = establishments(:one)
    est2 = establishments(:two)
    assert_equal({:lat => 43.6982039, :lng => -79.5027124}, est1.latlng_dict)
    assert_equal({:lat => 43.688205, :lng => -79.5027122}, est2.latlng_dict)
  end

end
