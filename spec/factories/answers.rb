FactoryGirl.define do
  factory :answer do
    question
    content  "Forty two. That's it. That's all there is."
  end

  factory :invalid_answer, class: 'Answer' do
    content nil
  end  
end
