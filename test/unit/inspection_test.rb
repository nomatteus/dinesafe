require 'test_helper'

class InspectionTest < ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods

  test "infractions by severity" do
    establishment = create(:establishment)
    inspection = create(:inspection, :establishment => establishment)

    create(:infraction, :significant, :inspection => inspection)
    create(:infraction, :crucial, :inspection => inspection)
    create(:infraction, :minor, :inspection => inspection)

    infractions = inspection.infractions_by_severity
    assert_equal 3, infractions.length
    assert_equal "C - Crucial", infractions[0].severity
    assert_equal "S - Significant", infractions[1].severity
    assert_equal "M - Minor", infractions[2].severity
  end
end
