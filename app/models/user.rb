class User < ApplicationRecord
  enum :status, { active: 0, blocked: 1 }
  normalizes :email, with: ->(email) { email.strip.downcase }
  validates :full_name, presence: true
  validates :email, presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP,
                      message: "e-mail address is not valid " }
  has_secure_password
  scope :by_last_seen, -> { order(Arel.sql("last_seen DESC NULLS LAST"), id: :asc) }
end
