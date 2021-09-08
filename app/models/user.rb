class User < ApplicationRecord
  has_secure_password
  before_save{email.downcase!}
  attr_accessor :remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :name, presence: true,
    length: {maximum: Settings.validator.user.name.max_length}
  validates :email, presence: true, uniqueness: true,
    length: {maximum: Settings.validator.user.email.max_length},
    format: {with: VALID_EMAIL_REGEX}
  validates :password, presence: true,
    length: {minimum: Settings.validator.user.pass.pass_min}, allow_nil: true

  scope :latest, ->{order created_at: :desc}
  scope :activated_true, ->{where(activated: true)}

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine.MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost: cost)
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_column :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_column :remember_digest, nil
  end
end
