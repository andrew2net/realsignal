class Address < ApplicationRecord
  belongs_to :user, inverse_of: :address
end
