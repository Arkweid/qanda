class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy

  validates :content, presence: true, length: { in: 5..1000 }
  validates :title, presence: true, length: { in: 5..50 }
end
