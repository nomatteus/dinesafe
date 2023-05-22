FactoryBot.define do
  factory :establishment do
    latest_name { "Bob's Diner" }
    latest_type { "Restaurant" }
    address { "123 Main St" }
    latlng { "43.6982039,-79.5027124" }

    # factory :establishment_with_inspections do
    #   ignore do
    #     inspections_count 5
    #   end

    #   after(:create) do |establishment, evaluator|
    #     FactoryBot.create_list(:inspection, evaluator.inspections_count, establishment: establishment)
    #   end
    # end
  end

  factory :inspection do
    establishment
    minimum_inspections_per_year { 1 }
    date { Date.new(2011, 11, 30) }
    establishment_name { "Bob's Diner" }
    establishment_type { "Restaurant" }

    trait :pass do
      status { "Pass" }
    end

    trait :conditional do
      status { "Conditional Pass" }
    end

    trait :closed do
      status { "Closed" }
    end

    trait :out_of_business do
      status { "Out of Business" }
    end
  end

  factory :infraction do
    inspection

    trait :crucial do
      severity { "C - Crucial" }
    end
    trait :significant do
      severity { "S - Significant" }
    end
    trait :minor do
      severity { "M - Minor" }
    end
  end
end
