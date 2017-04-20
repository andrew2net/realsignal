class Strategy < ApplicationRecord
  belongs_to :portfolio_strategy, inverse_of: :strategies
end
