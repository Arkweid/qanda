FactoryGirl.define do
  factory :comment do
    user
    content 'test comment'
  end

  factory :invalid_comment, class: 'Comment' do
    user
    content nil
  end
end
