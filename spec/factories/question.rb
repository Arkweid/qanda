FactoryGirl.define do
  sequence :title do |n|
    "Test title #{n}"
  end

  factory :question do
    user
    title
    content "Some question"
  end

  factory :invalid_question, class: 'Question' do
    title nil
    content nil
  end
end
