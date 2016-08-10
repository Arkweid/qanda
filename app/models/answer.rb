class Answer < ActiveRecord::Base
  belongs_to :question
  validates :question_id, presence: true
  validates :content, presence: true, length: { in: 10..1000 }
end
