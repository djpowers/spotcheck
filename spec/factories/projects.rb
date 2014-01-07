FactoryGirl.define do
  factory :project do
    title "Washington's Birthday Sales Event"
    description 'Regional ad campaign airing in Northeast Feb. 21 to Feb. 28'
    status 'UNAPPROVED'
    due_date Time.now + 1.weeks

    factory :project_with_owner do
      user
    end
  end
end
