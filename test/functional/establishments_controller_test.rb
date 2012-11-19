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
      "latest_name" => est1.latest_name,
      "latest_type" => est1.latest_type,
      "address" => est1.address,
      "latlng" => est1.latlng,
      }, {
      "id" => est2.id,
      "latest_name" => est2.latest_name,
      "latest_type" => est2.latest_type,
      "address" => est2.address,
      "latlng" => est2.latlng,
      }
      ]}, parsed_body)
  end

  test "index json search parameter" do
    est = establishments(:one)
    get :index, :format => :json, :search => "An establishment"
    parsed_body = JSON.parse(response.body)
    assert_response :success
    assert_equal 1, parsed_body["data"].length
    assert_equal est.id, parsed_body["data"][0]["id"]
  end

  test "index json near parameter" do
    est = establishments(:one)
    get :index, :format => :json, :near => "43.6982039,-79.5027124"
    parsed_body = JSON.parse(response.body)
    assert_response :success
    assert_equal 2, parsed_body["data"].length
    assert_equal est.id, parsed_body["data"][0]["id"]
  end

  test "index json near & search combined parameter" do
    est = establishments(:two)
    get :index, :format => :json, :search => "establishment", :near => "43.688205,-79.5027122"
    parsed_body = JSON.parse(response.body)
    assert_response :success
    assert_equal 2, parsed_body["data"].length
    assert_equal est.id, parsed_body["data"][0]["id"]
  end

end
