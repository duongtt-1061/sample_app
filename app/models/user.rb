class User < ApplicationRecord
  USER_PERMIT = %i(name email password password_confirmation).freeze
  attr_accessor :remember_token, :activation_token

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
                  },
                  allow_nil: true

  scope :activated, ->{where activated: true}

  before_save :downcase_email
  before_create :create_activation_digest

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

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false unless digest

    BCrypt::Password.new(digest).is_password? token
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update activated: Settings.status_activated, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
