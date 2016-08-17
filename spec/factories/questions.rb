FactoryGirl.define do
  factory :question do
    title 'Very important question'
    content 'Give me the Ultimate Question of Life, the Universe, and Everything'
  end

  factory :invalid_question, class: 'Question' do
    title nil
    content nil
  end
end
