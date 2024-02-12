FactoryBot.define do
    factory :post do
        date { Date.today }
        sequence(:rationale) { |n| "Rationale Content #{n}" }
        overtime_request { 3.5 }
        user
    end

    factory :second_post, class: 'Post' do
        date { Date.yesterday }
        sequence(:rationale) { |n| "Rationale Content #{n}" }
        overtime_request { 3.5 }
        user
    end

    factory :post_from_other_user, class: 'Post' do
        date { Date.yesterday }
        sequence(:rationale) { |n| "Rationale Content #{n}" }
        overtime_request { 3.5 }
        user
    end
end
