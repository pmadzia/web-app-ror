class User < ApplicationRecord
  enum :status, { active: 0, blocked: 1 }
  normalizes :email, with: ->(email) { email.strip.downcase }
  validates :full_name, presence: true
  validates :email, presence: true,
            format: { with: URI::MailTo::EMAIL_REGEXP,
                      message: "e-mail address is not valid " }
  has_secure_password
  scope :by_last_seen, -> { order(Arel.sql("last_seen DESC NULLS LAST"), id: :asc) }

  ransacker :last_seen_or_epoch do
    Arel.sql("COALESCE(users.last_seen, '-infinity')")
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[full_name email job_position status last_seen_or_epoch]
  end

  def self.ransackable_associations(_auth_object = nil)
    []
  end
end
