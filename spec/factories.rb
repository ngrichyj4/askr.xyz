# If we had a bigger project, these would belong in 
# /spec/factories/*.rb
# ... but this is not a bigger project. Let's not waste
# time on idealism

FactoryGirl.define do
  factory :poll do
    slug "poll_slug"
    voting_style :choose_one
  end
end
