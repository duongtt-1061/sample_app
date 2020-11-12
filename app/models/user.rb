class User < ApplicationRecord
  before_save :downcase_email
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

  private

  def downcase_email
    email.downcase!
  end
end
