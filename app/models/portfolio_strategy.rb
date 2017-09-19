class PortfolioStrategy < ApplicationRecord
  has_many :strategies, inverse_of: :portfolio_strategy
  has_many :subscription_types, inverse_of: :portfolio_strategy
end
