class User < ApplicationRecord
  before_save :downcase_email

  attr_accessor :remember_token

  USER_PERMIT = %i(name email password password_confirmation).freeze

  validates :name, presence: true,
                  length: {
                    maximum: Settings.validates.user.max_length_name_user
                  }
  validates :email, presence: true,
                  length: {
                    maximum: Settings.validates.user.max_length_email_user
                  },
                  format: {with: Settings.validates.user.valid_email_regex},
                  uniqueness: true
  has_secure_password
  validates :password, presence: true,
                  length: {
                    minimum: Settings.validates.user.min_length_pass_user
                  }

  class << self
    def digest string
      cost =
        if ActiveModel::SecurePassword.min_cost
          BCrypt::Engine::MIN_COST

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
    update_attribute :remember_digest, User.digest(remember_token)
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  private

  def downcase_email
    email.downcase!
  end
end
