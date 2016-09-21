class User < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def author_of?(object)
    object.user_id == id
  end

  def voted?(object)
    object.votes.where(user: self).exists?
  end

  def can_vote?(object)
    !author_of?(object) && !voted?(object)
  end
end
