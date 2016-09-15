class Question < ActiveRecord::Base
  include AdditionalMethods
  
  has_many :answers, dependent: :destroy
  has_many :attachments, as: :attachable, dependent: :destroy
  belongs_to :user

  validates :user_id, :content, :title, presence: true

  validates :content, length: { in: 5..1000 }
  validates :title, length: { in: 5..50 }

  accepts_nested_attributes_for :attachments, reject_if: :blank_file, allow_destroy: true
end
