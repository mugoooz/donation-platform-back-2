class Donation < ApplicationRecord
    belongs_to :charity
    belongs_to :donor
  
    validates :amount, :name, :location, :phone_number, presence: true
end