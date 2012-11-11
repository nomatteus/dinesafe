require 'test_helper'

class EstablishmentTest < ActiveSupport::TestCase

  test "establishment proximity search" do
    flunk
    # how to test :near scope?
    # create array of ~3 places (or add them to yaml)
    # then run scope with limit of 1 and make sure it's
    #  the closest one.
    # Or run with limit of 3 and check that they're all in
    # the correct order
  end

  test "establishment text search" do
    flunk
    # test that i can do a search for an establishment name and it returns results as expected
    # if i will support any other fields, then test those too, but probably not for now
  end

end
