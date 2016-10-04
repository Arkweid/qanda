class User < ActiveRecord::Base
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :authorizations, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, omniauth_providers: [:facebook, :twitter]

  def author_of?(object)
    object.user_id == id
  end

  def voted?(object)
    object.votes.where(user: self).exists?
  end

  def can_vote?(object)
    !author_of?(object) && !voted?(object)
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    email = auth.info[:email] || Forgery(:internet).email_address
    user = User.find_by(email: email)
    unless user
      password = Devise.friendly_token[0, 20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end
    
    user.create_authorization(auth)
    user
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end
end
