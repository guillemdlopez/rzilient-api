class Laptop < ApplicationRecord

    validates :code, presence: true, uniqueness: true
    validates :name, presence: true, uniqueness: true
    validates :code, format: { with: /\A[A-Z]{2}[1-9]{1}\z/, message: "'%{value}' must be in uppercase and it should contain 2 letters and 1 digit at the end" }
    validates :price, presence: true, numericality: { greater_than: 0 }
end
