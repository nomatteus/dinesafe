require 'test_helper'

class EstablishmentsControllerTest < ActionController::TestCase

  test "should get index json" do
    est1 = establishments(:one)
    est2 = establishments(:two)
    get :index, :format => :json
    parsed_body = JSON.parse(response.body)
    assert_response :success
    assert_equal 2, parsed_body["data"].length
    assert_equal({"data" => [{
      "id" => est1.id,
      "name" => est1.name,
      "est_type" => est1.est_type,
      "address" => est1.address,
      "postal_code" => est1.postal_code,
      "latlng" => est1.latlng,
      }, {
      "id" => est2.id,
      "name" => est2.name,
      "est_type" => est2.est_type,
      "address" => est2.address,
      "postal_code" => est2.postal_code,
      "latlng" => est2.latlng,
      }
      ]}, parsed_body)
  end

end
