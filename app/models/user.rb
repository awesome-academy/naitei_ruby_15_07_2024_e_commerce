class User < ApplicationRecord
  enum role: {user: 0, admin: 1}, _prefix: true
  VALID_EMAIL_REGEX = Regexp.new(Settings.value.valid_email)
  VALID_PHONE_REGEX = Regexp.new(Settings.value.phone_format)

  validates :user_name, presence: true,
    length: {maximum: Settings.value.max_user_name}
  validates :email, presence: true,
    length: {maximum: Settings.value.max_user_email},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: true
  validates :password, presence: true,
    length: {minimum: Settings.value.min_user_password},
    allow_nil: true
  validates :phone,
            length: {is: Settings.value.phone},
            format: {with: VALID_PHONE_REGEX}

  has_many :addresses, dependent: :destroy
  has_many :carts, dependent: :destroy
  has_many :feedbacks, dependent: :destroy
  has_one_attached :image
end
