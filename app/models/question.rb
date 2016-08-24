class Question < ActiveRecord::Base
  has_many :answers, dependent: :destroy
  belongs_to :user

  validates :user_id, :content, :title, presence: true

  validates :content, length: { in: 5..1000 }
  validates :title, length: { in: 5..50 }
end
