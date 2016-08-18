FactoryGirl.define do
  sequence :title do |n|
    "Test title #{n}"
  end

  sequence :content do |n|
    "Test content #{n}"
  end

  factory :question do
    title
    content
  end

  factory :invalid_question, class: 'Question' do
    title nil
    content nil
  end
end
