class User < ApplicationRecord
  has_secure_password
  before_save{email.downcase!}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :name, presence: true,
    length: {maximum: Settings.validator.user.name.max_length}
  validates :email, presence: true, uniqueness: true,
    length: {maximum: Settings.validator.user.email.max_length},
    format: {with: VALID_EMAIL_REGEX}

  def self.digest string
    cost = if ActiveModel::SecurePassword.min_cost
             BCrypt::Engine::MIN_COST
           else
             BCrypt::Engine.cost
           end
    BCrypt::Password.create string, cost: cost
  end
end
