FactoryGirl.define do
  factory :project do
    title "Washington's Birthday Sales Event"
    description 'Regional ad campaign airing in Northeast Feb. 21 to Feb. 28'
    status 'UNAPPROVED'
    due_date Date.today + 2.weeks
    due_time Time.now + 2.hours

    factory :project_with_owner do
      membership
    end
  end
end
