class User < ApplicationRecord
  before_save :downcase_email

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i .freeze
  validates :name, presence: true
  validates :email, presence: true, length: {maximum: Settings.digit.digit_255},
    format: {with: VALID_EMAIL_REGEX}

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
