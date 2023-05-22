require 'test_helper'

class InspectionTest < ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods

  test "infractions sort by severity" do
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

  test "infractions sort by severity with new severity doesn't break sort" do
    # Ensure sort method can handle severity values not in its default sort array
    # Anything not in that array should appear last in the list, and sorted alphabetically
    establishment = create(:establishment)
    inspection = create(:inspection, :establishment => establishment)

    create(:infraction, :severity => "n/a", :inspection => inspection)
    create(:infraction, :minor, :inspection => inspection)
    create(:infraction, :severity => "A - All right!", :inspection => inspection)

    infractions = inspection.infractions_by_severity
    assert_equal 3, infractions.length
    assert_equal "M - Minor", infractions[0].severity
    assert_equal "A - All right!", infractions[1].severity
    assert_equal "n/a", infractions[2].severity
  end
end
