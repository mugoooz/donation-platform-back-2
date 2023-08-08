class Charity < ApplicationRecord
  has_many :donations
  has_many :beneficiaries
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, :location, :phone_number, :purpose, presence: true
  validates :password, length: { minimum: 8 }, if: -> { new_record? || !password.nil? }
end
