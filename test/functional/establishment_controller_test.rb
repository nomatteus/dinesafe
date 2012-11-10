require 'test_helper'

class EstablishmentControllerTest < ActionController::TestCase
  test "search returns something" do
    get :search, :blah => "hi"
    response = JSON.parse(@response.body)
    assert_response :success
    assert_equal "hi", response["something"]
  end

end
