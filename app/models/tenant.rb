class Tenant < ApplicationRecord
  has_many :leases
  has_many :apartments, through: :leases

  validates :id, :name, :age, presence: true
  validates :age, numericality: { integer_only: true, greater_than_or_equal_to: 18 }
end
